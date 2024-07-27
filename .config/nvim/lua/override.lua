-- override defaults
local raw_p = print
-- note: print should return nil...
-- vim.print('') -> linebreak
-- vim.print('a', 'b') -> "a\nb"
---@return nil
print = function(...)
  -- vim.print(...)

  local pack = { ... }
  if #pack == 0 then
    raw_p('\n')
  else
    local i = vim.tbl_map(vim.inspect, pack)
    -- TODO: print/echomsg/notify ????
    -- how to print \t
    -- message don't contain cmd output...
    -- local s = table.concat(i, '\t')
    local s = table.concat(i, ' ')
    raw_p(s)
  end
  -- for _, v in pairs({ ... }) do
  --   -- raw_p(vim.inspect(v))
  -- end
  -- raw_p(vim.inspect('a'), vim.inspect())
  -- return
end

local get_parser = vim.treesitter.get_parser

---@diagnostic disable-next-line: duplicate-set-field
vim.treesitter.get_parser = function(bufnr, lang, opts)
  if bufnr == nil or bufnr == 0 then bufnr = api.nvim_get_current_buf() end
  if
    (function()
      if vim.bo[bufnr].ft == 'tex' then return true end
      return api.nvim_buf_line_count(bufnr) > 100000
    end)()
  then
    error('skip treesitter for large buf')
  end
  return get_parser(bufnr, lang, opts)
end
