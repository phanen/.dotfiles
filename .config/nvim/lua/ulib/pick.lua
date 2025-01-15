local f = require('fzf-lua') -- ensure g.fzf_lua_actions is setuped
local fe = require('fzf-lua-extra')
local libuv = require('fzf-lua.libuv')

local Pick = {}

-- curl -sLO https://github.com/phanen/file-web-devicons/releases/download/main/file_web_devicon-x86_64-unknown-linux-gnu
local options = {
  filter = not g.disable_icon and 'file_web_devicon', -- FIXME: for non-utf-8 input (e.g. binary test file)
  fd_cmd = [[fd --color=always --type f --hidden --follow -E .git]],
  rg_cmd = [[rg --pcre2 --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e ]],
  glob_regex = '(.*)%s%-%-%s(.*)',
}

local filter_wrap = function(cmd)
  if true then return cmd end
  return options.filter
      and fn.executable(options.filter) == 1
      and ('%s | %s'):format(cmd, options.filter)
    or cmd
end

---@param str string
---@return string
local rg_escape = function(str) -- also escape `,`: for bug: FZF_DEFAULT_OPTS="" fzf --bind 'start:reload(echo "),")'
  return (str:gsub('[%(|%)|\\|%[|%]|%-|%{%}|%?|%+|%*|%^|%$|%.,]', '\\%1'))
end

Pick.files = function(opts)
  local default = {
    cache = true,
    previewer = 'builtin',
    actions = g.fzf_lua_actions.files,
  }
  opts = u.merge(default, opts or {})
  local cwd = opts.cwd or uv.cwd()
  local g = vim.tbl_map(libuv.shellescape, u.project(cwd).iglobs or {})
  local cmd = table.concat({ options.fd_cmd, unpack(g) }, ' -E ')
  return f.fzf_exec(filter_wrap(cmd), opts)
end

---@param query string query
---@param globs string[] globs have been built
local get_grep_cmd = function(query, globs)
  local q_search, q_glob = query:match(options.glob_regex)
  local q = libuv.shellescape(q_search or query)
  local g = q_glob and vim.list_extend(vim.split(q_glob, '%s+', { trimempty = true }), globs)
    or globs
  g = vim.tbl_map(libuv.shellescape, g) -- escape glob pattern
  local cmd = table.concat({ options.rg_cmd .. q, unpack(g) }, ' -g ')
  return filter_wrap(cmd)
end

Pick.grep = function(opts)
  local default = {
    previewer = 'builtin',
    actions = u.merge(
      g.fzf_lua_actions.files,
      { ['ctrl-g'] = function() Pick.lgrep { no_esc = true, query = f.get_last_query() } end }
    ),
    input_prompt = 'Grep> ',
  }
  local input = function(prompt)
    local ok, res
    ok, res = pcall(fn.input, { prompt = prompt, cancelreturn = 3 })
    if res == 3 then
      ok, res = false, nil
    end
    return ok and res or nil
  end
  opts = u.merge(default, opts or {})
  opts.query = opts.query and (opts.no_esc and opts.query or rg_escape(opts.query))
  local cwd = opts.cwd or uv.cwd()
  local ig = vim.tbl_map(function(g) return '!' .. g end, u.project(cwd).iglobs or {})
  local q = (opts.query and #opts.query ~= 0) and opts.query or input(opts.input_prompt) or ''
  return f.fzf_exec(get_grep_cmd(q, ig), opts)
end

Pick.lgrep = function(opts)
  local default = {
    previewer = 'builtin',
    actions = u.merge(
      g.fzf_lua_actions.files,
      { ['ctrl-g'] = function() Pick.grep { no_esc = true, query = f.get_last_query() } end }
    ),
  }
  opts = u.merge(default, opts or {})
  opts.query = opts.query and (opts.no_esc and opts.query or rg_escape(opts.query))
  local cwd = opts.cwd or uv.cwd()
  local ig = vim.tbl_map(function(g) return '!' .. g end, u.project(cwd).iglobs or {})
  opts.fn_reload = function(q) return get_grep_cmd(q, ig) end
  return f.fzf_exec(nil, opts)
end

-- Pick.lgrep = f.live_grep_glob

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
      query = f.get_last_query(),
      no_esc = true,
      winopts = { title = '[' .. curr_title .. ']' },
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

-- create notes, snips or todos
local create_notes = function(_, opts)
  local todo_dir = '~/notes/todo'
  local snip_dir = '~/notes/snip'

  local query = f.get_last_query()
  if not query or query == '' then query = os.date('%m-%d') .. '.md' end
  local parts = vim.split(query, ' ', { trimempty = true })
  local part_nr = #parts
  if part_nr == 0 then return end

  -- multi fields, append todo
  if part_nr > 1 then
    local tag = parts[1]
    local content = table.concat(parts, ' ', 2)
    local path = fn.expand(fs.joinpath(todo_dir, tag)) .. '.md'
    content = ('* %s\n'):format(content)
    local ok = u.fs.write_file(path, content, 'a')
    if not ok then return vim.notify('fail to write to storage', vim.log.levels.WARN) end
    return
  end

  -- query as path
  local path_parts = vim.split(query, '.', { plain = true, trimempty = true })

  if #path_parts == 0 then
    return -- dot only
  end

  -- complete name default to md
  if #path_parts == 1 then
    query = query .. '.md'
    path_parts[2] = 'md'
  end

  -- router (query can be `a/b/c`)
  local path
  if path_parts[2] == 'md' then
    path = fn.expand(fs.joinpath(opts.cwd, query))
  else
    path = fn.expand(fs.joinpath(snip_dir, query))
  end

  vim.cmd.edit(path)
end

-- stylua: ignore
Pick.dots = make_mux_from_pair(Pick.files, Pick.lgrep, 'FILES_DOTS', 'LGREP_DOTS', { cwd = '~' }, { cwd = '~' })
-- stylua: ignore
Pick.nvim = make_mux_from_pair(Pick.files, Pick.lgrep, 'FILES_NVIM', 'LGREP_NVIM', { cwd = env.VIMRUNTIME }, { cwd = env.VIMRUNTIME })
-- stylua: ignore
Pick.notes = make_mux_from_pair(
  Pick.files, Pick.lgrep, 'FILES_NOTES', 'LGREP_NOTES',
  { cwd = g.notes_path or '~/notes', actions = { ['ctrl-n'] = create_notes } },
  { cwd = g.notes_path or '~/notes' }
)

-- stylua: ignore
Pick.find_dir = function()
  return f.fzf_exec('find_dir', {
    preview = 'eza --color=always --tree --level=3 --icons=always {}',
    winopts = { preview = { hidden = true } },
    actions = {
      ['enter'] = function(s) return u.misc.cd(s[1]) end,
      ['ctrl-l'] = { fn = function(s) return u.pick.files { cwd = s[1] } end, reuse = true },
      ['ctrl-n'] = { fn = function(s) return u.pick.lgrep { cwd = s[1] } end, reuse = true },
      ['ctrl-x'] = { fn = function(s) return vim.system { 'zoxide', 'remove', s[1] } end, reload = true },
    },
  })
end

local fzf_lua_pickers = u.cache.one(function()
  local exclude = require('fzf-lua')._excluded_metamap or {}
  return vim
    .iter(u.merge(f, {}, Pick or {}, fe or {}))
    :filter(function(v) return not exclude[v] end)
    :fold({}, function(acc, k)
      u.com['Fl' .. u.string.snake_to_camel(k)] = u.pick[k]
      acc[k] = true
      return acc
    end)
end)

Pick.builtin = function(opts)
  local default = {
    actions = { enter = function(s) return s[1] and u.pick[s[1]]() end }, -- cannot noclose, win size may change
  }
  opts = f.config.normalize_opts(u.merge(default, opts or {}), 'builtin')
  opts = u.merge(default, opts or {})
  opts.metatable = fzf_lua_pickers()
  return require 'fzf-lua.providers.module'.metatable(opts)
end

Pick.commands = function(opts)
  fzf_lua_pickers() -- setup ocmmands
  require('fzf-lua').commands(opts)
end

Pick.todos = function(opts)
  opts = u.merge({
    previewer = 'builtin',
    actions = g.fzf_lua_actions.files,
    todo_pattern = 'TODO|HACK|PERF|NOTE|FIXME',
  }, opts or {})
  return f.fzf_exec(options.rg_cmd .. libuv.shellescape(opts.todo_pattern), opts)
end

local no_query = { resume = true, git_bcommits = true }

return setmetatable({}, {
  __index = function(_, k)
    local override_opts = k ~= 'resume'
      and { winopts = { title = '[' .. u.string.snake_to_camel(k) .. ']' } }
    local p = Pick[k] or f[k] or fe[k]
    return function(call_opts)
      if Pick[k] then require('fzf-lua').set_info { mod = 'pick', cmd = k, fnc = k } end
      return p(
        u.merge(
          no_query[k] and {} or { query = table.concat(u.buf.getregion()) },
          override_opts or {},
          call_opts or {}
        )
      )
    end
  end,
})
