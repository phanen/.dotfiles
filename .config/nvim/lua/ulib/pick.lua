local flo = require('flo')
local fzf = require('fzf-lua') -- ensure g.fzf_lua_file_actions is setuped
local libuv = require('fzf-lua.libuv')

local Pick = {}
-- FIXME(upstream): unable to stat netrw 'https://'

-- curl -sLO https://github.com/phanen/file-web-devicons/releases/download/main/file_web_devicon-x86_64-unknown-linux-gnu
local options = {
  iconprg = 'file_web_devicon', -- FIXME: for non-utf-8 input (e.g. binary test file)
  fd_cmd = [[fd --color=never --type f --hidden --follow --exclude .git]],
  rg_cmd = [[rg --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e ]],
  -- not sure if is this a sorter-friendly opt-in
  -- fzf_opts = { ['--nth'] = 2, ['--delimiter'] = fzf.utils.nbsp },
  glob_regex = '(.*)%s%-%-%s(.*)',
}

---@alias content (string|number)[]|fun(fzf_cb: fun(entry?: string|number, cb?: function))|string|nil
---@param contents content
---@param opts? {fn_reload: string|function, fn_transform: function, __fzf_init_cmd: string, _normalized: boolean}
local fzf_exec = function(contents, opts)
  local default = { query = table.concat(u.buf.getregion()) }
  return fzf.fzf_exec(contents, u.merge(default, opts or {}))
end

---@param str string
---@return string
local rg_escape = function(str)
  -- also escape `,` here, a workaournd for bug: FZF_DEFAULT_OPTS="" ./fzf --bind 'start:reload(echo ")")'
  return (str:gsub('[%(|%)|\\|%[|%]|%-|%{%}|%?|%+|%*|%^|%$|%.,]', '\\%1'))
end

Pick.files = function(opts)
  local default = {
    multiprocess = false,
    previewer = 'builtin',
    winopts = { title = '[FILES]', title_pos = 'center' },
    fzf_opts = options.fzf_opts,
    actions = g.fzf_lua_file_actions,
  }
  opts = u.merge(default, opts or {})
  local ignore_globs = u.project.get('ignore_globs', { cwd = opts.cwd }) or {}
  local cmd = options.fd_cmd
  cmd = table.concat({ cmd, unpack(vim.tbl_map(libuv.shellescape, ignore_globs)) }, ' -E ')
  if not g.disable_icon and options.iconprg and fn.executable(options.iconprg) == 1 then
    cmd = ('%s | %s'):format(cmd, options.iconprg)
  end
  return fzf_exec(cmd, opts)
end

local get_grep_cmd = function(query, inv_globs)
  local search_query, glob_query = query:match(options.glob_regex)
  local globs = vim.deepcopy(inv_globs)
  if search_query and glob_query then
    local query_globs = vim.split(glob_query, '%s+', { trimempty = true })
    globs = vim.list_extend(globs, query_globs)
  else
    search_query = query
  end
  search_query = libuv.shellescape(search_query)
  globs = vim.tbl_map(libuv.shellescape, globs)
  local cmd = table.concat({ options.rg_cmd .. search_query, unpack(globs) }, ' -g ')
  return not g.disable_icon
      and options.iconprg
      and fn.executable(options.iconprg) == 1
      and ('%s | %s'):format(cmd, options.iconprg)
    or cmd
end

Pick.grep = function(opts)
  local default = {
    multiprocess = false,
    previewer = 'builtin',
    query = rg_escape(table.concat(u.buf.getregion())),
    winopts = { title = '[GREP]', title_pos = 'center' },
    fzf_opts = options.fzf_opts,
    actions = u.merge(
      g.fzf_lua_file_actions,
      { ['ctrl-g'] = function() Pick.lgrep { query = fzf.get_last_query() } end }
    ),
    input_prompt = 'Grep> ',
  }
  local input = function(prompt)
    local ok, res
    ok, res = pcall(vim.fn.input, { prompt = prompt, cancelreturn = 3 })
    if res == 3 then
      ok, res = false, nil
    end
    return ok and res or nil
  end
  opts = u.merge(default, opts or {})
  local ignore_globs = u.project.get('ignore_globs', { cwd = opts.cwd }) or {}
  local inv_globs = vim.tbl_map(function(g) return '!' .. g end, ignore_globs)
  local query = (opts.query and #opts.query ~= 0) and opts.query or input(opts.input_prompt) or ''
  return fzf_exec(get_grep_cmd(query, inv_globs), opts)
end

Pick.lgrep = function(opts)
  local default = {
    multiprocess = false,
    previewer = 'builtin',
    query = rg_escape(table.concat(u.buf.getregion())),
    winopts = { title = '[LGREP]', title_pos = 'center' },
    fzf_opts = options.fzf_opts,
    actions = u.merge(
      g.fzf_lua_file_actions,
      { ['ctrl-g'] = function() Pick.grep { query = fzf.get_last_query() } end }
    ),
    prompt = '',
  }
  opts = u.merge(default, opts or {})
  opts.prompt = (opts.prompt and opts.prompt:match('^%*')) and opts.prompt or ('*' .. opts.prompt)
  local ignore_globs = u.project.get('ignore_globs', { cwd = opts.cwd }) or {}
  local inv_globs = vim.tbl_map(function(g) return '!' .. g end, ignore_globs)
  opts.fn_reload = function(query) return get_grep_cmd(query, inv_globs) end
  return fzf_exec(nil, opts)
end

-- Picker.lgrep = fzf.live_grep_glob

---@param picker function
local make_picker_persist = function(picker)
  local build_opts_from_state = function() -- maybe this hack don't work well...
    return { resume = true, query = '' }
  end

  return function(opts)
    local default = build_opts_from_state()
    return picker(opts, u.merge(default, opts or {}))
  end
end

---@param a function "on_launch"
---@param b function first toggle to
---@param a_title string extra name to be used by title...
---@param b_title string be messy without this...
---@param a_opts? table predefine opts
---@param b_opts? table the same as above
---@param persist? boolean kept "property" during toggle (e.g. fullscreen/preview)
---@param key? string toggle key, default to ctrl-g
local make_mux_from_pair = function(a, b, a_title, b_title, a_opts, b_opts, persist, key)
  a_opts = a_opts or {}
  b_opts = b_opts or {}
  key = key or 'ctrl-g'

  local curr, curr_title, curr_opts = a, a_title, a_opts

  if persist then
    a = make_picker_persist(a)
    b = make_picker_persist(b)
  end

  -- state usually fullscreen/toggle-preview/toggle
  local toggle_state = function()
    curr = curr == a and b or a
    curr_title = curr == a and a_title or b_title
    curr_opts = curr == a and a_opts or b_opts
    return curr
  end

  local function make_toggle_opts()
    local opts = {
      query = fzf.get_last_query(),
      winopts = { title = '[' .. curr_title .. ']', title_pos = 'center' },
      actions = {
        [key] = {
          fn = function() return toggle_state()(make_toggle_opts()) end,
          -- TODO: win update title
          -- noclose = true,
          -- reload = true,
        },
      },
    }
    return u.merge(curr_opts, opts)
  end

  return function(opts)
    local default = make_toggle_opts()
    default.query = nil -- first call (query will be handled by picker itself)
    return curr(u.merge(default, opts or {}))
  end
end

-- stylua: ignore
Pick.dots = make_mux_from_pair(Pick.files, Pick.lgrep, 'FILES_DOTS', 'LGREP_DOTS', { cwd = '~' }, { cwd = '~' })
-- stylua: ignore
Pick.nvim = make_mux_from_pair(Pick.files, Pick.lgrep, 'FILES_NVIM', 'LGREP_NVIM', { cwd = env.VIMRUNTIME }, { cwd = env.VIMRUNTIME })
-- stylua: ignore
Pick.notes = make_mux_from_pair(
  Pick.files, Pick.lgrep, 'FILES_NOTES', 'LGREP_NOTES',
  { cwd = '~/notes', actions = { ['ctrl-n'] = require('flo.actions').create_notes } },
  { cwd = '~/notes' }
)

-- stylua: ignore
Pick.zoxide = function()
  return fzf_exec('realpath ~/b/* ~/.local/share/nvim/lazy/* ~/dot/* ', {
    preview = 'eza --color=always --tree --level=3 --icons=always {}',
    actions = {
      ['enter'] = function(s) return u.misc.cd(s[1]) end,
      ['ctrl-l'] = { fn = function(s) return u.pick.files { cwd = s[1] } end, noclose = true },
      ['ctrl-n'] = { fn = function(s) return u.pick.lgrep { cwd = s[1] } end, noclose = true },
      ['ctrl-x'] = { fn = function(s) return vim.system { 'zoxide', 'remove', s[1] } end, reload = true },
    },
  })
end

Pick.builtin = function(opts)
  local default = {
    builtin_extends = Pick,
    actions = { -- cannot use noclose/reload, since win size may change
      ['enter'] = function(s) return s[1] and Pick[s[1]]() end,
    },
  }
  opts = u.merge(default, opts or {})
  return flo.builtin(opts)
end

Pick.todos = function(opts)
  opts = u.merge({
    previewer = 'builtin',
    actions = g.fzf_lua_file_actions,
  }, opts or {})
  return fzf_exec(options.rg_cmd .. libuv.shellescape('TODO|HACK|PERF|NOTE|FIXME'), opts)
end

setmetatable(Pick, { __index = flo })

return Pick
