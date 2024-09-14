local Fs = {}

---read file contents
---@param path string
---@return string?
Fs.read_file = function(path)
  local file = io.open(path, 'r')
  if not file then return end
  local content = file:read('*a')
  file:close()
  return content
end

---write string into file
---@param path string
---@param content string
---@param flags string?
---@return boolean success
Fs.write_file = function(path, content, flags)
  local file = io.open(path, flags or 'w')
  if not file then return false end
  file:write(content)
  file:close()
  return true
end

Fs.must_read_file = function(path) return assert(Fs.read_file(path)) end

Fs.must_write_file = function(path, content, flags)
  return assert(Fs.write_file(path, content, flags) == 0)
end

Fs.must_filecopy = function(from, to) return assert(fn.filecopy(from, to) == 0) end

Fs.must_writefile = function(lines, path, flags)
  if flags then return assert(fn.writefile(lines, path, flags) == 0) end
  return assert(fn.writefile(lines, path) == 0)
end

--- recursive find files
---@param root string
---@param fn fun(fname: string, name: string, path: string): boolean?
Fs.walk = function(root, fn)
  Fs.ls(root, function(fname, name, type)
    if type == 'directory' then Fs.walk(fname, fn) end
    return fn(fname, name, type)
  end)
end

---sync
---@param path string
---@param fn fun(fname: string, name: string, path: string): boolean?
Fs.ls = function(path, fn)
  for name, type in fs.dir(path) do
    local fname = fs.joinpath(path, name)
    if fn(fname, name, type or uv.fs_stat(fname).type) == false then break end
  end
end

---Read json contents as lua table
---@param path string
---@param opts table? same option table as `vim.json.decode()`
---@return table
Fs.read_json = function(path, opts)
  opts = opts or {}
  local content = Fs.read_file(path)
  local ok, tbl = pcall(vim.json.decode, content, opts)
  return ok and tbl or {}
end

---Write json contents
---@param path string
---@param tbl table
---@return boolean success
Fs.write_json = function(path, tbl)
  local ok, content = pcall(vim.json.encode, tbl)
  if not ok then return false end
  return Fs.write_file(path, content)
end

return Fs
