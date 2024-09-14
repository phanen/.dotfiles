local Lsp = {}

---@return lsp.ClientCapabilities
local make_capabilities = function()
  local ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
  local lsp_cap = vim.lsp.protocol.make_client_capabilities()
  local cmp_cap = ok and cmp_nvim_lsp.default_capabilities()
  return u.merge(lsp_cap or {}, cmp_cap or {})
end

Lsp.make_capabilities = make_capabilities
---Lsp.make_capabilities = vim.func._memoize(nil, make_capabilities, true)

return Lsp
