local M = {}

local lazy_config = require('lazy.core.config')
local patch_dir = fs.joinpath(g.config_path, 'patches')

local hl_echo = function(msg, hl) return api.nvim_echo({ { msg, hl } }, true, {}) end

-- FIXME(unkown): write lazy.lua in lazy.nvim root??
---@param should_patch boolean
M.lazy_patch = function(should_patch)
  u.fs.ls(patch_dir, function(path, name, _)
    local plug_path = fs.joinpath(lazy_config.options.root, (name:gsub('%.patch$', '')))
    if not uv.fs_stat(plug_path) then return end
    u.git { 'restore', '.', cwd = plug_path }:wait()
    if should_patch then
      local obj = u.git { 'apply', '--ignore-space-change', path, cwd = plug_path }:wait()
      if obj.code == 0 then
        -- TODO: if devicon not loaded, this hlgroup not work
        hl_echo('Patched: ' .. name, 'DevIconVimrc')
      else
        hl_echo('Failed:  ' .. name, 'Error')
      end
    end
  end)
end

M.lazy_cache_docs = function()
  -- note: seems not loaded when LazyInstall
  if g.disable_cache_docs then
    -- for _, plugin in pairs(lazy_config.plugins) do
    --   local docs = fs.joinpath(plugin.dir, 'doc')
    --   if uv.fs_stat(docs) then pcall(vim.cmd.helptags, docs) end
    -- end
    return
  end
  local docs_path = fs.joinpath(g.docs_path, 'doc')
  fn.mkdir(docs_path, 'p')
  u.fs.ls(docs_path, function(path, _, _)
    if type == 'file' then uv.fs_unlink(path) end
  end)
  for _, plugin in pairs(lazy_config.plugins) do
    local docs = fs.joinpath(plugin.dir, 'doc')
    if uv.fs_stat(docs) then
      u.fs.ls(docs, function(path, name, type)
        if type ~= 'file' then return true end
        if name == 'tags' then
          uv.fs_unlink(path)
        elseif name:sub(-4) == '.txt' then
          uv.fs_copyfile(path, fs.joinpath(docs_path, name))
        end
      end)
    end
  end
  pcall(vim.cmd.helptags, docs_path)
end

-- used by keymap
M.lazy_chore_update = function()
  M.lazy_patch(true)
  M.lazy_cache_docs()
end

return M
