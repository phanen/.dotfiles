local M = {}

---@param path string
---@return table<string, fun(...): any>
M.reqcall = function(path)
  return setmetatable({}, {
    __index = function(_, k)
      return function(...) return require(path)[k](...) end
    end,
  })
end

--- get visual text string
---@return string
M.get_visual = function()
  local reg_bak = vim.fn.getreg "v"
  vim.fn.setreg("v", {})
  -- do nothing in normal mode
  vim.cmd [[noau normal! "vy\<esc\>]]
  local sel_text = vim.fn.getreg "v"
  vim.fn.setreg("v", reg_bak)
  return sel_text
end

return M
