local M = {}

-- FIXME(unkown): write lazy.lua in lazy.nvim root??
M.lazy_patch = function()
  local patches_path = vim.fs.joinpath(vim.g.config_path, 'patches')
  for patch_name in vim.fs.dir(patches_path) do
    local lazy_root = require('lazy.core.config').options.root
    local plug_path = vim.fs.joinpath(lazy_root, (patch_name:gsub('%.patch$', '')))
    if not uv.fs_stat(plug_path) then return end
    vim.notify('Restore begin: ' .. patch_name)
    fn.system { 'git', '-C', plug_path, 'restore', '.' }
    vim.notify('Restore done:  ' .. patch_name)
    local patch_path = vim.fs.joinpath(patches_path, patch_name)
    vim.notify('Patch begin:    ' .. patch_name)
    fn.system { 'git', '-C', plug_path, 'apply', '--ignore-space-change', patch_path }
    vim.notify('Patch done:     ' .. patch_name)
  end
end

M.lazy_patch_callback = function(info)
  vim.g._lz_syncing = vim.g._lz_syncing or info.match == 'LazySyncPre'
  if vim.g._lz_syncing and not info.match:find('^LazySync') then return end
  if info.match == 'LazySync' then vim.g._lz_syncing = nil end
  local patches_path = vim.fs.joinpath(vim.g.config_path, 'patches')
  for patch_name in vim.fs.dir(patches_path) do
    local lazy_root = require('lazy.core.config').options.root
    local plug_path = vim.fs.joinpath(lazy_root, (patch_name:gsub('%.patch$', '')))
    if not uv.fs_stat(plug_path) then return end
    vim.notify('Restore begin: ' .. patch_name)
    fn.system { 'git', '-C', plug_path, 'restore', '.' }
    vim.notify('Restore done:  ' .. patch_name)
    if not info.match:find('Pre$') then
      local patch_path = vim.fs.joinpath(patches_path, patch_name)
      vim.notify('Patch begin:    ' .. patch_name)
      fn.system { 'git', '-C', plug_path, 'apply', '--ignore-space-change', patch_path }
      vim.notify('Patch done:     ' .. patch_name)
    end
  end
end

M.lazy_cache_docs = function()
  -- note: seems not loaded when LazyInstall
  local lazy_util = require('lazy.util')
  local lazy_config = require('lazy.core.config')
  if g.disable_cache_docs then
    return (function()
      for _, plugin in pairs(lazy_config.plugins) do
        local docs = vim.fs.joinpath(plugin.dir, 'doc')
        if lazy_util.file_exists(docs) then
          vim.print(docs)
          pcall(vim.cmd.helptags, docs)
        end
      end
    end)()
  end
  local docs_path = vim.fs.joinpath(vim.g.docs_path, 'doc')
  fn.mkdir(docs_path, 'p')
  lazy_util.ls(docs_path, function(path, _, _)
    if type == 'file' then uv.fs_unlink(path) end
  end)
  for _, plugin in pairs(lazy_config.plugins) do
    local docs = vim.fs.joinpath(plugin.dir, 'doc')
    if lazy_util.file_exists(docs) then
      lazy_util.ls(docs, function(path, name, type)
        if type ~= 'file' then return true end
        if name == 'tags' then
          uv.fs_unlink(path)
        elseif name:sub(-4) == '.txt' then
          uv.fs_copyfile(path, vim.fs.joinpath(docs_path, name))
        end
      end)
    end
  end
  pcall(vim.cmd.helptags, docs_path)
end

-- used by keymap
M.lazy_chore_update = function()
  M.lazy_patch()
  M.lazy_cache_docs()
end

return M
