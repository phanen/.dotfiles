---@module 'util'
local u = {}

local getregion = function(mode)
  local sl, sc = vim.fn.line 'v', vim.fn.col 'v'
  local el, ec = vim.fn.line '.', vim.fn.col '.'
  if sl > el then
    sl, sc, el, ec = el, ec, sl, sc
  elseif sl == el and sc > ec then
    sc, ec = ec, sc
  end
  local lines = vim.api.nvim_buf_get_lines(0, sl - 1, el, false)
  if mode == 'v' then
    if #lines == 1 then
      lines[1] = lines[1]:sub(sc, ec)
    else
      lines[1] = lines[1]:sub(sc)
      lines[#lines] = lines[#lines]:sub(1, ec)
    end
  elseif mode == '\022' then -- not sure behavior
    for i, line in pairs(lines) do
      if #line >= ec then
        lines[i] = line:sub(sc, ec)
      elseif #line < sc - 1 then
        lines[i] = (' '):rep(ec - sc + 1)
      elseif #line < sc then
        lines[i] = ''
      else
        lines[i] = line:sub(sc, nil)
      end
    end
  end
  return lines
end

-- get visual selected with no side effect
u.getregion = function(mode)
  mode = mode or vim.api.nvim_get_mode().mode
  if not vim.tbl_contains({ 'v', 'V', '\022' }, mode) then return {} end
  local ok, lines = pcall(vim.fn.getregion, vim.fn.getpos '.', vim.fn.getpos 'v', { type = mode })
  if ok then return lines end
  return getregion(mode)
end

-- -- redirect buf open to other window
-- au('Filetype', {
--   pattern = { 'qf', 'NvimTree', 'help', 'man', 'aerial', 'fugitive*' },
--   callback = function(args)
--     -- if vim.bo.bt ~= '' then map('n', 'q', '<cmd>q<cr>', { buffer = args.buf }) end
--     -- TODO: winfixbuf not always work...
--   end,
-- })

-- UNKOWN: check ft here as workaround for autocmd not always work
local ft_tbl = setmetatable({
  ['qf'] = true,
  ['NvimTree'] = true,
  ['help'] = true,
  ['man'] = true,
  ['aerial'] = true,
}, {
  __index = function(_, k) return k:match('fugitive*') and true or false end,
})

u.smart_quit = function()
  -- close floating window
  local curwind = vim.api.nvim_get_current_win()
  if vim.api.nvim_win_get_config(curwind).relative ~= '' or ft_tbl[vim.bo.ft] then
    return vim.api.nvim_win_close(curwind, true)
  end

  -- close all focusable floating windows
  local count = 0
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_is_valid(win) then
      local cfg = vim.api.nvim_win_get_config(win)
      if cfg.relative ~= '' and cfg.focusable then -- unfocusable(e.g. fidget)
        vim.api.nvim_win_close(win, false)
        count = count + 1
      end
    end
  end

  if count == 0 then -- fallback
    vim.api.nvim_feedkeys(vim.keycode('q'), 'n', false)
  end
end

u._lazy_patch = function()
  local patches_path = vim.fs.joinpath(vim.g.config_path, 'patches')
  for patch_name in vim.fs.dir(patches_path) do
    local lazy_root = require('lazy.core.config').options.root
    local plug_path = vim.fs.joinpath(lazy_root, (patch_name:gsub('%.patch$', '')))
    if not vim.uv.fs_stat(plug_path) then return end
    vim.notify('Restore begin: ' .. patch_name)
    vim.fn.system { 'git', '-C', plug_path, 'restore', '.' }
    vim.notify('Restore done:  ' .. patch_name)
    local patch_path = vim.fs.joinpath(patches_path, patch_name)
    vim.notify('Patch begin:    ' .. patch_name)
    vim.fn.system { 'git', '-C', plug_path, 'apply', '--ignore-space-change', patch_path }
    vim.notify('Patch done:     ' .. patch_name)
  end
end

u.lazy_patch = function(info)
  vim.g._lz_syncing = vim.g._lz_syncing or info.match == 'LazySyncPre'
  if vim.g._lz_syncing and not info.match:find('^LazySync') then return end
  if info.match == 'LazySync' then vim.g._lz_syncing = nil end
  local patches_path = vim.fs.joinpath(vim.g.config_path, 'patches')
  for patch_name in vim.fs.dir(patches_path) do
    local lazy_root = require('lazy.core.config').options.root
    local plug_path = vim.fs.joinpath(lazy_root, (patch_name:gsub('%.patch$', '')))
    if not vim.uv.fs_stat(plug_path) then return end
    vim.notify('Restore begin: ' .. patch_name)
    vim.fn.system { 'git', '-C', plug_path, 'restore', '.' }
    vim.notify('Restore done:  ' .. patch_name)
    if not info.match:find('Pre$') then
      local patch_path = vim.fs.joinpath(patches_path, patch_name)
      vim.notify('Patch begin:    ' .. patch_name)
      vim.fn.system { 'git', '-C', plug_path, 'apply', '--ignore-space-change', patch_path }
      vim.notify('Patch done:     ' .. patch_name)
    end
  end
end

u.lazy_cache_docs = function()
  local lazy_util = package.loaded['lazy.util']
  local lazy_config = package.loaded['lazy.core.config']
  local docs_path = vim.fs.joinpath(vim.g.docs_path, 'doc')
  vim.fn.mkdir(docs_path, 'p')
  lazy_util.ls(docs_path, function(path, _, _)
    if type == 'file' then vim.uv.fs_unlink(path) end
  end)
  for _, plugin in pairs(lazy_config.plugins) do
    local docs = vim.fs.joinpath(plugin.dir, 'doc')
    if lazy_util.file_exists(docs) then
      lazy_util.ls(docs, function(path, name, type)
        if type ~= 'file' then return end
        if name == 'tags' then
          vim.uv.fs_unlink(path)
        elseif name:sub(-4) == '.txt' then
          vim.uv.fs_copyfile(path, vim.fs.joinpath(docs_path, name))
        end
      end)
    end
  end
  vim.cmd.helptags(docs_path)
end

u.qf_toggle = function()
  if vim.iter(vim.fn.getwininfo()):any(function(win) return win.quickfix == 1 end) then
    vim.cmd.cclose()
  else
    vim.cmd.copen()
  end
end

u.qf_delete = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local qflist = vim.fn.getqflist()
  local linenr = vim.api.nvim_win_get_cursor(0)[1]
  local mode = vim.api.nvim_get_mode().mode
  if mode:match('[vV]') then
    local first_line = vim.fn.getpos("'<")[2]
    local last_line = vim.fn.getpos("'>")[2]
    qflist = vim
      .iter(qflist)
      :filter(function(_, i) return i < first_line or i > last_line end)
      :totable()
  else
    table.remove(qflist, linenr)
  end
  -- replace items in the current list, do not make a new copy of it; this also preserves the list title
  vim.fn.setqflist({}, 'r', { items = qflist })
  vim.fn.setpos('.', { bufnr, linenr, 1, 0 }) -- restore current line
end

-- UNKOWN: twice?
au('Filetype', {
  pattern = 'qf',
  callback = function(ev)
    map('n', 'dd', '<cmd>lua require("util").qf_delete()<cr>', { buffer = true })
  end,
})

u.gitroot = function(bufname)
  bufname = bufname and bufname or vim.api.nvim_buf_get_name(0)
  local path = vim.fs.dirname(bufname)
  local root = vim.system { 'git', '-C', path, 'rev-parse', '--show-toplevel' }:wait().stdout
  if root then
    root = vim.trim(root)
  else
    for dir in vim.fs.parents(bufname) do
      if vim.fn.isdirectory(dir .. '/.git') == 1 then
        root = dir
        break
      end
    end
  end
  return root
end

-- iterate window to find good bufname
-- the buffer you are working on...
u.smart_bufname = function()
  -- current win should be check first...
  local wins = vim.api.nvim_list_wins() -- nvim_tabpage_list_wins(0)
  local curwinid = vim.api.nvim_get_current_win()
  -- btw, nvim-tree/neo-tree has a bufname...
  if vim.fn.win_gettype(curwinid) == '' then
    local bufnr = vim.api.nvim_win_get_buf(curwinid)
    if vim.bo[bufnr].bt ~= 'nofile' then
      local bufname = vim.api.nvim_buf_get_name(bufnr)
      if bufname ~= '' then return bufname end
    end
  end
  for _, winid in pairs(wins) do
    if winid ~= curwinid then
      local wt = vim.fn.win_gettype(winid)
      if wt == '' then
        local bufnr = vim.api.nvim_win_get_buf(winid)
        if vim.bo[bufnr].bt ~= 'nofile' then
          local bufname = vim.api.nvim_buf_get_name(bufnr)
          if bufname ~= '' then return bufname end
        end
      end
    end
  end
end

-- gitroot or parent of `working buffer`
u.smart_root = function()
  local bufname = vim.fn.resolve(u.smart_bufname()) -- follow symbolic link
  local root = u.gitroot(bufname)

  -- not in gitroot
  -- or in homedir(repo), but ignored
  local homedir = vim.env.HOME
  if
    not root
    or root == homedir
      and 0 == vim.system { 'git', '-C', homedir, 'check-ignore', '-q', bufname }:wait().code
  then
    return vim.fs.dirname(bufname)
  end
  return root
end

u.smart_cd = function() vim.api.nvim_set_current_dir(u.smart_root()) end

u.yank_filename = function()
  local path = vim.fs.normalize(vim.api.nvim_buf_get_name(0))
  vim.fn.setreg('+', (path:gsub(('^%s'):format(vim.env.HOME), '~')))
end

u.yank_message = function() vim.fn.setreg('+', vim.trim(vim.fn.execute('1message'))) end

u.force_close_tabpage = function()
  if #vim.api.nvim_list_tabpages() == 1 then
    vim.cmd('quit!')
  else
    vim.cmd('tabclose!')
  end
end

return u
