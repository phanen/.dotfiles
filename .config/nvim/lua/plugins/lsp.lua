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
      { "folke/neodev.nvim", ft = "lua", opts = {} },
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
  {
    "nvimtools/none-ls.nvim",
    cond = false,
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local nls = require "null-ls"
      nls.setup {
        on_attach = wtf_attch_why_this_is_allowed,
        sources = {
          nls.builtins.formatting.shfmt,
          nls.builtins.formatting.prettier,
          nls.builtins.formatting.stylua,
          nls.builtins.formatting.rustfmt.with {
            extra_args = function(params)
              local Path = require "plenary.path"
              local cargo_toml = Path:new(params.root .. "/" .. "Cargo.toml")

              if cargo_toml:exists() and cargo_toml:is_file() then
                for _, line in ipairs(cargo_toml:readlines()) do
                  local edition = line:match [[^edition%s*=%s*%"(%d+)%"]]
                  if edition then return { "--edition=" .. edition } end
                end
              end
              -- default edition when we don't find `Cargo.toml` or the `edition` in it.
              return { "--edition=2021" }
            end,
          },
          nls.builtins.formatting.black,

          -- nls.builtins.code_actions.eslint_d,
          nls.builtins.diagnostics.eslint_d,
          nls.builtins.formatting.eslint_d,
        },
      }
    end,
  },
}
