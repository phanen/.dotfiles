return {
  { "neovim/nvim-lspconfig", cmd = { "LspInfo", "LspInstall", "LspUninstall" } },
  { "j-hui/fidget.nvim", cond = false, event = "LspAttach", opts = {} },
  { "williamboman/mason.nvim", build = ":MasonUpdate", cmd = "Mason", opts = {} },
  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    -- event = "VeryLazy",
    dependencies = {
      { "williamboman/mason.nvim" },
      { "folke/neodev.nvim", cond = false, ft = "lua", opts = {} },
    },
    config = function()
      -- local capabilities = require "capabilities"
      local lspconfig = require "lspconfig"
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      require("mason-lspconfig").setup {
        handlers = {
          function(server)
            lspconfig[server].setup {
              capabilities = capabilities,
            }
          end,
          lua_ls = function()
            lspconfig.lua_ls.setup {
              on_attach = function(client, _)
                -- NOTE: regard this as LspAttachPre
                -- which formatter should be used?
                -- client.server_capabilities.documentFormattingProvider = false
              end,
              capabilities = capabilities,
              settings = {
                Lua = {
                  hint = {
                    enable = true,
                    setType = true,
                  },
                  completion = {
                    callSnippet = "Replace",
                    postfix = ".",
                    showWord = "Disable",
                    workspaceWord = false,
                  },
                  format = {
                    defaultConfig = {
                      call_arg_parentheses = "remove_table_only",
                      add_comma = "comma",
                    },
                  },
                },
              },
            }
          end,
          yamlls = function()
            lspconfig.yamlls.setup {
              capabilities = capabilities,
              settings = {
                yaml = {
                  keyOrdering = false,
                  schemaStore = {
                    enable = false,
                    url = "",
                  },
                  schemas = require("schemastore").yaml.schemas(),
                },
              },
            }
          end,
        },
      }
    end,
  },
  "b0o/schemastore.nvim",
}
