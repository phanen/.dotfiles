local Lsp = {}

-- TODO: cache?
local make_capabilities = function()
  local ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
  local lsp_cap = vim.lsp.protocol.make_client_capabilities()
  local cmp_cap = ok and cmp_nvim_lsp.default_capabilities()
  return vim.tbl_deep_extend('force', lsp_cap, cmp_cap)
end

-- no args (cache var but not cache table...)
-- Lsp.make_capabilities = vim.func._memoize(1, make_capabilities, true)
-- means that we just cache var (not table)
-- Lsp.make_capabilities = vim.func._memoize(nil, make_capabilities, true)
-- Lsp.make_capabilities = make_capabilities
Lsp.make_capabilities = u.cache_one(make_capabilities)

return Lsp
