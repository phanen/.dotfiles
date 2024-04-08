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
  if not vim.tbl_contains({ 'v', 'V', '\022' }, mode) then
    return {}
  end
  local ok, lines = pcall(vim.fn.getregion, vim.fn.getpos '.', vim.fn.getpos 'v', { type = mode })
  if ok then
    return lines
  end
  return getregion(mode)
end

u.q = function()
  local count = 0
  local current_win = vim.api.nvim_get_current_win()
  -- Close current win only if it's a floating window
  if vim.api.nvim_win_get_config(current_win).relative ~= '' then
    vim.api.nvim_win_close(current_win, true)
    return
  end
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_is_valid(win) then
      local config = vim.api.nvim_win_get_config(win)
      -- Close floating windows that can be focused
      if config.relative ~= '' and config.focusable then
        vim.api.nvim_win_close(win, false) -- do not force
        count = count + 1
      end
    end
  end
  if count == 0 then -- Fallback
    vim.api.nvim_feedkeys(vim.keycode('q'), 'n', false)
  end
end

u.lazy_patch = function(info)
  vim.g._lz_syncing = vim.g._lz_syncing or info.match == 'LazySyncPre'
  if vim.g._lz_syncing and not info.match:find('^LazySync') then
    return
  end
  if info.match == 'LazySync' then
    vim.g._lz_syncing = nil
  end
  local patches_path = vim.fs.joinpath(vim.fn.stdpath('config'), 'patches')
  for patch_name in vim.fs.dir(patches_path) do
    local lazy_root = require('lazy.core.config').options.root
    local plugin_path = vim.fs.joinpath(lazy_root, (patch_name:gsub('%.patch$', '')))
    if not vim.uv.fs_stat(plugin_path) then
      return
    end
    vim.notify('Restore begin: ' .. patch_name)
    vim.fn.system { 'git', '-C', plugin_path, 'restore', '.' }
    vim.notify('Restore done:  ' .. patch_name)
    if not info.match:find('Pre$') then
      local patch_path = vim.fs.joinpath(patches_path, patch_name)
      vim.notify('Patch begin:    ' .. patch_name)
      vim.fn.system { 'git', '-C', plugin_path, 'apply', '--ignore-space-change', patch_path }
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
    if type == 'file' then
      vim.uv.fs_unlink(path)
    end
  end)
  for _, plugin in pairs(lazy_config.plugins) do
    local docs = vim.fs.joinpath(plugin.dir, 'doc')
    if lazy_util.file_exists(docs) then
      lazy_util.ls(docs, function(path, name, type)
        if type ~= 'file' then
          return
        end
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

u.toggle_qf = function()
  local qf_win = vim
    .iter(vim.fn.getwininfo())
    :filter(function(win)
      return win.quickfix == 1
    end)
    :totable()
  if #qf_win == 0 then
    vim.cmd.copen()
  else
    vim.cmd.cclose()
  end
end

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

u.cd_gitroot_or_parent = function()
  local bufname = vim.api.nvim_buf_get_name(0)
  local root = u.gitroot(bufname)
  if not root then
    vim.fs.dirname(bufname)
  end
  vim.api.nvim_set_current_dir(root)
end

u.yank_filename = function()
  local path = vim.fs.normalize(vim.api.nvim_buf_get_name(0))
  path = (path:gsub(('^%s'):format(vim.env['HOME']), '~'))
  vim.fn.setreg('+', path)
end

u.yank_message = function()
  local text = vim.fn.execute('1message')
  vim.fn.setreg('+', vim.trim(text))
end

return u
