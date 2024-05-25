local M = {}

M.root_patterns = {
  '.git/',
  '.svn/',
  '.bzr/',
  '.hg/',
  '.project/',
  '.pro',
  '.sln',
  '.vcxproj',
  'Makefile',
  'makefile',
  'MAKEFILE',
  '.gitignore',
  '.editorconfig',
}

---Compute project directory for given path.
---@param path string?
---@param patterns string[]? root patterns
---@return string? nil if not found
M.proj_dir = function(path, patterns)
  if not path or path == '' then return nil end
  patterns = patterns or M.root_patterns
  local stat = uv.fs_stat(path)
  if not stat then return end
  local dirpath = stat.type == 'directory' and path or vim.fs.dirname(path)
  for _, pattern in ipairs(patterns) do
    local root = vim.fs.find(pattern, {
      path = dirpath,
      upward = true,
      type = pattern:match('/$') and 'directory' or 'file',
    })[1]
    if root and uv.fs_stat(root) then
      local dirname = vim.fs.dirname(root)
      return dirname and uv.fs_realpath(dirname) --[[@as string]]
    end
  end
end

---read file contents
---@param path string
---@return string?
M.read_file = function(path)
  local file = io.open(path, 'r')
  if not file then return nil end
  local content = file:read('*a')
  file:close()
  return content or ''
end

---write string into file
---@param path string
---@return boolean success
M.write_file = function(path, str)
  local file = io.open(path, 'w')
  if not file then return false end
  file:write(str)
  file:close()
  return true
end

-- require('lazy.core.util').ls
M.ls = function(path, fn)
  local handle = uv.fs_scandir(path)
  while handle do
    local name, type = uv.fs_scandir_next(handle)
    if not name then break end
    local fname = vim.fs.joinpath(path, name)
    -- HACK: type is not always returned
    -- https://github.com/folke/lazy.nvim/issues/306
    if fn(fname, name, type or uv.fs_stat(fname).type) == false then break end
  end
end

------@param _fn fun(string: string)
---local walk_mod = function(_fn)
---  local path = env.MYVIMRC or require('lib.debug').script_path()
---  local mod_path = vim.fs.dirname(path) .. '/lua/mod/'
---  local b = {
---    ['vscode'] = true,
---  }
---  -- TODO: use luv, maybe slow?
---  for file in vim.fs.dir(mod_path) do
---    local modname, _ = file:match('(.+).lua')
---    if not b[modname] then _fn('mod.' .. modname) end
---  end
---end
---
----- walk_mod(print)

return M
