local lsp, fs, fn, api, fmt = vim.lsp, vim.fs, vim.fn, vim.api, string.format
local M = {}

local function get_keymap()
  -- encapsulation to prevent err on load telescope
  return {
    { '<leader>rn', lsp.buf.rename, 'rename' },
    { '<leader>=', lsp.buf.format, 'full format' },
    { 'gD', lsp.buf.declaration, 'goto declaration' },
    { 'gd', lsp.buf.definition, 'goto definition'},
    { 'gI', lsp.buf.implementation, 'goto implementation' },
    { 'gr', require('telescope.builtin').lsp_references, 'goto references' },
    { '<leader>D', lsp.buf.type_definition, 'type definition' },
    { 'K', lsp.buf.hover, 'hover documentation' },
  }
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

function M.lsp_attach(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then desc = 'LSP: ' .. desc end
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end
  for _, v in pairs(get_keymap()) do nmap(unpack(vim.tbl_values(v))) end
end

M.lsp_servers = {
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
  clangd = {},
  rust_analyzer = {},
  gopls = {},
  pyright = {},
  tsserver = {},
}

return M
