local fmt = string.fmt
local M = {}

function M.get_nvim_version()
  local version = vim.version()
  return string.format('%d.%d.%d', version.major, version.minor, version.patch)
end

-- M.dev_dir = vim.env.DEV_DIR or vim.fn.expand('~/demo')

---@param require_path string
---@return table<string, fun(...): any>
function M.reqcall(require_path)
  return setmetatable({}, {
    __index = function(_, k)
      return function(...) return require(require_path)[k](...) end
    end,
  })
end

return M
