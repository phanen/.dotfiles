local Fs = {}

Fs.root_patterns = {
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
Fs.proj_dir = function(path, patterns)
  if not path or path == '' then return nil end
  patterns = patterns or Fs.root_patterns
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
Fs.read_file = function(path)
  local file = io.open(path, 'r')
  if not file then return nil end
  local content = file:read('*a')
  file:close()
  return content or ''
end

---write string into file
---@param path string
---@return boolean success
Fs.write_file = function(path, str)
  local file = io.open(path, 'w')
  if not file then return false end
  file:write(str)
  file:close()
  return true
end

-- require('lazy.core.util').ls
Fs.ls = function(path, fn)
  local handle = uv.fs_scandir(path)
  while handle do
    local name, type = uv.fs_scandir_next(handle)
    if not name then break end
    local fname = fs.joinpath(path, name)
    -- HACK: type is not always returned
    -- https://github.com/folke/lazy.nvim/issues/306
    if fn(fname, name, type or uv.fs_stat(fname).type) == false then break end
  end
end

-- path normalized, get lazily by coroutine...
Fs.ls2 = function(path, fn)
  for name, type in fs.dir(path) do
    local fname = fs.joinpath(path, name)
    if fn(fname, name, type or uv.fs_stat(fname).type) == false then break end
  end
end

------@param _fn fun(string: string)
---local walk_mod = function(_fn)
---  local path = env.MYVIMRC or u.debug.script_path()
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

---Read json contents as lua table
---@param path string
---@param opts table? same option table as `vim.json.decode()`
---@return table
Fs.read_json = function(path, opts)
  opts = opts or {}
  local str = Fs.read_file(path)
  local ok, tbl = pcall(vim.json.decode, str, opts)
  return ok and tbl or {}
end

---Write json contents
---@param path string
---@param tbl table
---@return boolean success
Fs.write = function(path, tbl)
  local ok, str = pcall(vim.json.encode, tbl)
  if not ok then return false end
  return Fs.write_file(path, str)
end

return Fs
