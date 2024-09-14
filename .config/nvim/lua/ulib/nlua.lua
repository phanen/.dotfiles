-- 'mrjones2014/lua-gf.nvim'

local Nlua = {}

-- Iterator that splits a string on a given delimiter
local function split(str, delim)
  delim = delim or '%s'
  return string.gmatch(str, string.format('[^%s]+', delim))
end

-- Search for lua traditional include paths.
-- This mimics how require internally works.
local function include_paths(fname)
  local paths = string.gsub(package.path, '%?', fname)
  for path in split(paths, '%;') do
    if vim.fn.filereadable(path) == 1 then return path end
  end
end

-- Search for nvim lua include paths
local function include_rtpaths(fname, ext)
  ext = ext or 'lua'
  local rtpaths = vim.api.nvim_list_runtime_paths()
  local modfile, initfile = string.format('%s.%s', fname, ext), string.format('init.%s', ext)
  for _, path in ipairs(rtpaths) do
    -- Look on runtime path for 'lua/*.lua' files
    local path1 = table.concat({ path, ext, modfile }, '/')
    if vim.fn.filereadable(path1) == 1 then return path1 end
    -- Look on runtime path for 'lua/*/init.lua' files
    local path2 = table.concat({ path, ext, fname, initfile }, '/')
    if vim.fn.filereadable(path2) == 1 then return path2 end
  end
end

-- Global function that searches the path for the required file
Nlua.rtp_find_required_path = function(module)
  pcall(require, module) -- for lazy-loading environments, make sure it's on runtimepath
  -- Look at package.config for directory separator string (it's the first line)
  local sep = string.match(package.config, '^[^\n]')
  -- Properly change '.' to separator (probably '/' on *nix and '\' on Windows)
  local fname = vim.fn.substitute(module, '\\.', sep, 'g')
  return include_paths(fname) or include_rtpaths(fname)
end

return Nlua
