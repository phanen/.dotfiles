---@module "lib.bufop"
local Misc = {}

Misc.quit = function()
  if vim.bo.bt == 'help' then vim.cmd('quit!') end
  if fn.reg_recording() ~= '' or fn.reg_executing() ~= '' then
    return api.nvim_feedkeys('q', 'n', false)
  end

  -- quit Linediff
  if vim.wo.diff then return vim.cmd('quit!') end

  if api.nvim_win_get_config(0).relative ~= '' then -- close current float
    return vim.cmd('quit!')
  end

  -- close all focusable float (:fclose! ?)
  local count
  vim
    .iter(api.nvim_tabpage_list_wins(0))
    :filter(api.nvim_win_is_valid)
    :filter(function(win) -- -- skip unfocusable(e.g. fidget)
      local cfg = api.nvim_win_get_config(win)
      return cfg.relative ~= '' and cfg.focusable and true or false
    end)
    :each(function(win)
      api.nvim_win_call(win, function() vim.cmd('quit!') end)
      count = true
    end)
  if count then return end
  return api.nvim_feedkeys('q', 'n', false)
end

--- find "correct" buffer
--- prefer informative buffer (skip `noname`, `nofile`)
--- useful to run cmd(e.g. git) on correct buffer
---@return { winid: integer, bufnr: integer, bufname: string }
Misc.find_best_winbuf = function()
  local buf, name
  local ok_then_set = function(win)
    if u.is.win_float(win) then return false end
    buf = api.nvim_win_get_buf(win)
    if vim.bo[buf].bt == 'nofile' then return false end -- e.g. exclude Nvimtree
    name = api.nvim_buf_get_name(buf)
    return name ~= ''
  end

  local cwin = api.nvim_get_current_win()
  if ok_then_set(cwin) then return { winid = cwin, bufnr = buf, bufname = name } end
  local win = vim
    .iter(api.nvim_tabpage_list_wins(0))
    :find(function(win) return win ~= cwin and ok_then_set(win) end)
  return { winid = win, bufnr = buf, bufname = name }
end

Misc.cd = function(path)
  ---@return string
  local find_root = function()
    local bufname = Misc.find_best_winbuf().bufname
    bufname = fn.resolve(bufname)
    -- prefer git root
    local root = u.git.root { bufname = bufname }
    local home = env.HOME

    --- if files fallback into dotfiles (but `gitignored`)
    ---    or files is not managed in git root
    if
      not root
      or root == home and u.git { 'check-ignore', '-q', bufname, cwd = home }:wait().code == 0
    then
      return fs.dirname(bufname)
    end
    return root
  end

  path = path or find_root()
  -- uv.chdir (no event?), fn.chdir, cmd.cd
  api.nvim_set_current_dir(path)
  if fn.executable('zoxide') == 1 then vim.system { 'zoxide', 'add', path } end
end

Misc.qf_or_ll_toggle = function()
  local ll_open = vim.iter(fn.getwininfo()):any(function(win) return win.loclist == 1 end)
  if ll_open then return vim.cmd.lclose() end
  local qf_open = vim.iter(fn.getwininfo()):any(function(win) return win.quickfix == 1 end)
  if qf_open then return vim.cmd.cclose() end
  local ll_unopen = #fn.getloclist(0) ~= 0
  if ll_unopen then return vim.cmd.lopen() end
  vim.cmd.copen()
end

Misc.mimic_wincmd = function()
  api.nvim_feedkeys(vim.keycode '<c-w>', 'n', true)
  local char = fn.getcharstr()
  api.nvim_feedkeys(char, 'n', true)
  if char ~= 'g' then return end
end

Misc.one_win_then = function(cmd_one, cmd_else)
  local focusables = #vim
    .iter(api.nvim_tabpage_list_wins(0))
    :filter(api.nvim_win_is_valid)
    :filter(function(win) return api.nvim_win_get_config(win).focusable end)
    :totable()

  if focusables == 1 then return vim.cmd(cmd_one) end
  return vim.cmd(cmd_else)
end

Misc.comment = function(lnum) -- https://github.com/neovim/neovim/discussions/28995
  local row = fn.line '.'
  local comment_row = row + lnum
  local l_cms, r_cms = string.match(vim.bo.commentstring, '(.*)%%s(.*)')
  l_cms = vim.trim(l_cms)
  r_cms = vim.trim(r_cms)
  if #r_cms ~= 0 then r_cms = ' ' .. r_cms end
  api.nvim_buf_set_lines(0, comment_row, comment_row, false, { l_cms .. ' ' .. r_cms })
  api.nvim_win_set_cursor(0, { comment_row + 1, 0 })
  vim.cmd('normal! ==')
  api.nvim_win_set_cursor(0, { comment_row + 1, #api.nvim_get_current_line() - #r_cms - 1 })
  api.nvim_feedkeys('a', 'n', true)
end

---@cmd
Misc.keywordprg = function(_) -- fallback: lsp -> ?
  local bufnr = api.nvim_get_current_buf()
  if u.is.has_lsp(bufnr) then return vim.lsp.buf.hover() end
end

Misc.edit_ftplugin = function(ft)
  if not ft then ft = vim.bo.ft end
  if ft:match('%s+') then return end
  local path = ('%s/after/ftplugin/%s.lua'):format(g.config_path, ft)
  vim.cmd.vsplit(path)
end

Misc.append_modeline = function()
  local modeline = ('vim: ts=%d sw=%d tw=%d %set :'):format(
    vim.o.tabstop,
    vim.o.shiftwidth,
    vim.o.textwidth,
    vim.o.expandtab and '' or 'no'
  )
  modeline = vim.bo.commentstring:format(modeline)
  api.nvim_buf_set_lines(0, -1, -1, false, { modeline })
  vim.cmd.doautocmd('BufRead')
end

Misc.archive = function()
  g.archive_dir = g.archive_dir
  local dir = env.HOME .. '/b/extra'
  local path = fs.joinpath(dir, fn.expand('%:t'))
  u.refactor.to_file(path, true)
end

---@autocmd
Misc.lazy_patch_autocmd = function(ev)
  g._lz_syncing = g._lz_syncing or ev.match == 'LazySyncPre'
  if g._lz_syncing and not ev.match:find('^LazySync') then return end
  if ev.match == 'LazySync' then g._lz_syncing = nil end
  local should_patch = not ev.match:find('Pre$')
  u.script.update_chore(should_patch)
end

---@autocmd
Misc.bigfile_preset = function(ev)
  local stat = uv.fs_stat(ev.match)
  if stat and stat.size > 1000000 then
    vim.b.bigfile = true
    vim.wo.spell = false
    vim.bo.swapfile = false
    vim.bo.undofile = false
    vim.bo.syntax = ''
    vim.wo.colorcolumn = ''
    vim.wo.statuscolumn = ''
    vim.wo.signcolumn = 'no'
    vim.wo.foldcolumn = '0'
    vim.wo.winbar = ''
    api.nvim_create_autocmd(
      'BufReadPost',
      { once = true, buffer = ev.buf, callback = function() vim.bo.syntax = '' end }
    )
  end
end

---@autocmd
Misc.record_bdelete = function(ev) -- vim.g seems buggy
  if not _G.__recent_hlist then _G.__recent_hlist = u.hashlist {} end
  -- ignore no name buffer on enter...
  if api.nvim_buf_get_name(ev.buf) == '' then return end
  _G.__recent_hlist:access(ev.match)
end

---@autocmd
Misc.update_idl = function(is_local)
  local new_opt
  if vim.o.et then
    local sw = vim.o.sw == 0 and vim.o.ts or vim.o.sw
    new_opt = { tab = '› ', leadmultispace = g.indentsym .. (' '):rep(sw - 1) }
  else
    new_opt = { tab = g.indentsym .. ' ', leadmultispace = '␣' }
  end
  local opt = is_local and vim.opt_local or vim.opt
  opt.listchars = opt.listchars + new_opt
end

---@autocmd
Misc.lz_shada = function()
  local shada_read ---@boolean?
  ---@return true
  local rshada = function()
    if shada_read then return true end
    shada_read = true
    vim.cmd.set('shada&')
    pcall(vim.cmd.rshada)
    return true
  end
  vim.schedule(rshada)
  return true
end

Misc.auto_lua_require = function(client, bufnr)
  --- @param x string
  --- @return string?
  local function match_require(x)
    -- WIP: match u.xx?
    return x:match('require')
      and (
        x:match("require%s*%(%s*'([^.']+).*'%)")
        or x:match('require%s*%(%s*"([^."]+).*"%)')
        or x:match("require%s*'([^.']+).*'%)")
        or x:match('require%s*"([^."]+).*"%)')
      )
  end

  if client.workspace_folders then
    local path = client.workspace_folders[1].name
    if uv.fs_stat(path .. '/.luarc.json') or uv.fs_stat(path .. '/.luarc.jsonc') then
      -- Updates to settings are igored if a .luarc.json is present
      return
    end

    -- local fd = uv.fs_open(root_dir .. '/.luarc.json', 'r', 438)
    -- local luarc = vim.json.decode(assert(vim.uv.fs_read(fd, vim.uv.fs_fstat(fd).size)))
    -- if not (luarc.workspace and luarc.workspace.library) then return end
  end

  client.settings = u.merge({ Lua = { workspace = { library = {} } } }, client.settings)

  --- @param first? integer
  --- @param last? integer
  local function on_lines(first, last)
    local do_change = false

    local lines = api.nvim_buf_get_lines(bufnr, first or 0, last or -1, false)
    for _, line in ipairs(lines) do
      local m = match_require(line)
      if m then
        for _, mod in ipairs(vim.loader.find(m, { patterns = { '', '.lua' } })) do
          local lib = fs.dirname(mod.modpath)
          local libs = client.settings.Lua.workspace.library
          if not vim.tbl_contains(libs, lib) then
            libs[#libs + 1] = lib
            do_change = true
          end
        end
      end
    end

    if do_change then
      client.notify('workspace/didChangeConfiguration', { settings = client.settings })
    end
  end

  api.nvim_buf_attach(bufnr, false, {
    on_lines = function(_, _, _, first, _, last) on_lines(first, last) end,
    on_reload = function() on_lines() end,
  })
  on_lines()
end

return Misc
