local M = {}

---@param sources winbar_source_t[]
---@return winbar_source_t
M.fallback = function(sources)
  return {
    get_symbols = function(buf, win, cursor)
      for _, source in ipairs(sources) do
        local symbols = source.get_symbols(buf, win, cursor)
        if not vim.tbl_isempty(symbols) then return symbols end
      end
      return {}
    end,
  }
end

return M
