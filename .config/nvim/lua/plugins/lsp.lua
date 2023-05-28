local lsp_attach = require("utils.lsp").lsp_attach
local lsp_servers = require("utils.lsp").lsp_servers
local capabilities = require("utils.lsp").capabilities

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "folke/neodev.nvim",
        ft = "lua",
        opts = { library = { plugins = { "nvim-dap-ui" } } },
      },
      {
        "folke/neoconf.nvim",
        cmd = { "Neoconf" },
        opts = { local_settings = ".nvim.json", global_settings = "nvim.json" },
      },
    },
  },

  -- status updates for lsp
  {
    "j-hui/fidget.nvim",
    lazy = false,
    config = true,
  },

  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    cmd = "Mason",
    config = true,
    -- opts = { ui = { border = border, height = 0.8 } },
  },

  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      local mlsp = require("mason-lspconfig")
      mlsp.setup({ ensure_installed = vim.tbl_keys(lsp_servers) })
      mlsp.setup_handlers({
        function(server_name)
          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
            on_attach = lsp_attach,
            settings = lsp_servers[server_name],
          })
        end,
        -- ['texlab'] = function () require('lspconfig').texlab.setup({ end })
      })
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason.nvim", "null-ls.nvim" },
    config = function()
      local null_ls = require("null-ls")
      require("mason-null-ls").setup({
        automatic_setup = true,
        automatic_installation = true,
        ensure_installed = { "buf", "goimports", "golangci_lint", "stylua", "prettier" },
        handlers = {
          sql_formatter = function()
            null_ls.register(null_ls.builtins.formatting.sql_formatter.with({
              extra_filetypes = { "pgsql" },
              args = function(params)
                local config_path = params.cwd .. "/.sql-formatter.json"
                if vim.loop.fs_stat(config_path) then
                  return { "--config", config_path }
                end
                return { "--language", "postgresql" }
              end,
            }))
          end,
          eslint = function()
            null_ls.register(null_ls.builtins.diagnostics.eslint.with({ extra_filetypes = { "svelte" } }))
          end,
        },
      })
      null_ls.setup()
    end,
  },
}
