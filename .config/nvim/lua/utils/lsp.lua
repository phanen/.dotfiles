local lsp, fs, fn, api, fmt = vim.lsp, vim.fs, vim.fn, vim.api, string.format
local M = {}

local capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
-- M.capabilities.offsetEncoding = 'utf-8'

function M.lsp_attach(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then desc = "LSP: " .. desc end
    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  local tb = require "telescope.builtin"

  nmap("<leader>rn", lsp.buf.rename, "rename")
  -- TODO: need multiply undo
  nmap("<leader>gg", lsp.buf.format, "format buffer")
  nmap("K", lsp.buf.hover, "hover documentation")
  nmap("gD", lsp.buf.declaration, "goto declaration")
  nmap("gd", lsp.buf.definition, "goto definition")
  nmap("gI", lsp.buf.implementation, "goto implementation")
  nmap("gr", tb.lsp_references, "goto references")
  nmap("<leader>D", lsp.buf.type_definition, "type definition")

  -- for _, v in pairs(get_keymap()) do
  --   nmap(unpack(vim.tbl_values(v)))
  -- end
end

M.lsp_servers = {
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
  clangd = {},
  -- rust_analyzer = {},
  -- gopls = {},
  -- pyright = {},
  -- tsserver = {},
  -- jsonls = {
  --   settings = {
  --     json = {
  --       schemas = require("schemastore").json.schemas(),
  --       validate = { enable = true },
  --     },
  --   },
  -- },
  yamlls = {
    schemaStore = {
      -- You must disable built-in schemaStore support if you want to use
      -- this plugin and its advanced options like `ignore`.
      enable = false,
    },
    schemas = require("schemastore").yaml.schemas(),
  },
  -- marksman = {},
}

return M
