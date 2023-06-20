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
    tag = "legacy",
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
      local mlsp = require "mason-lspconfig"
      mlsp.setup { ensure_installed = vim.tbl_keys(lsp_servers) }
      mlsp.setup_handlers {
        function(server_name)
          require("lspconfig")[server_name].setup {
            capabilities = capabilities,
            on_attach = lsp_attach,
            settings = lsp_servers[server_name],
          }
        end,
        ["rust_analyzer"] = function()
          local rt = require "rust-tools"
          rt.setup {
            server = {
              on_attach = function(_, bufnr)
                -- Hover actions
                vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
                -- Code action groups
                vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
              end,
            },
          }
        end,
        -- ['texlab'] = function () require('lspconfig').texlab.setup({ end })
      }
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local nls = require "null-ls"
      nls.setup {
        -- on_attach = lsp_attach,
        -- on_init = function(new_client, _)
        --   new_client.offset_encoding = "utf-16"
        -- end,
        sources = {
          -- nls.builtins.diagnostics.cspell,
          -- nls.builtins.code_actions.cspell,

          nls.builtins.code_actions.shellcheck,
          nls.builtins.diagnostics.shellcheck,
          -- .with {
          --       diagnostics_format = "[#{c}] #{m} (#{s})",
          --       diagnostic_config = {
          --         -- see :help vim.diagnostic.config()
          --         underline = true,
          --         virtual_text = false,
          --         signs = true,
          --         update_in_insert = true,
          --         severity_sort = true,
          --       },
          --     }
          -- nls.builtins.completion.spell,

          nls.builtins.formatting.shfmt,
          nls.builtins.formatting.prettier, -- markdown formatting
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

          nls.builtins.code_actions.eslint_d,
          nls.builtins.diagnostics.eslint_d,
          nls.builtins.formatting.eslint_d,
          -- nls.builtins.diagnostics.markdownlint,
          -- require "nu-ls",
        },
      }
      -- TODO: on_attach of null-ls don't work
      -- lsp_attach()
      -- vim.cmd "map <Leader>gg :lua vim.lsp.buf.format({timeout_ms = 2000})<CR>"
      -- vim.keymap.set("n", "<leader>go", "<cmd>lua vim.lsp.buf.code_action()<CR>")
    end,
  },
  -- {
  --   "jay-babu/mason-null-ls.nvim",
  --   event = { "BufReadPre", "BufNewFile" },
  --   dependencies = { "mason.nvim", "null-ls.nvim" },
  --
  --   config = function()
  --     local nls = require "null-ls"
  --
  --     require("mason-null-ls").setup {
  --       automatic_setup = false,
  --       automatic_installation = false,
  --       ensure_installed = { "buf", "goimports", "golangci_lint", "stylua", "prettier" },
  --       handlers = {
  --         sql_formatter = function()
  --           nls.register(nls.builtins.formatting.sql_formatter.with {
  --             extra_filetypes = { "pgsql" },
  --             args = function(params)
  --               local config_path = params.cwd .. "/.sql-formatter.json"
  --               if vim.loop.fs_stat(config_path) then return { "--config", config_path } end
  --               return { "--language", "postgresql" }
  --             end,
  --           })
  --         end,
  --         eslint = function() nls.register(nls.builtins.diagnostics.eslint.with { extra_filetypes = { "svelte" } }) end,
  --       },
  --     }
  --
  --     -- nls.setup {
  --     --   on_attach = lsp_attach,
  --     --   sources = {
  --     --     -- nls.builtins.diagnostics.cspell,
  --     --     -- nls.builtins.code_actions.cspell,
  --     --
  --     --     nls.builtins.code_actions.shellcheck,
  --     --     nls.builtins.diagnostics.shellcheck,
  --     --     -- .with {
  --     --     --       diagnostics_format = "[#{c}] #{m} (#{s})",
  --     --     --       diagnostic_config = {
  --     --     --         -- see :help vim.diagnostic.config()
  --     --     --         underline = true,
  --     --     --         virtual_text = false,
  --     --     --         signs = true,
  --     --     --         update_in_insert = true,
  --     --     --         severity_sort = true,
  --     --     --       },
  --     --     --     }
  --     --     nls.builtins.completion.spell,
  --     --
  --     --     nls.builtins.formatting.shfmt,
  --     --     nls.builtins.formatting.prettier, -- markdown formatting
  --     --     nls.builtins.formatting.stylua,
  --     --     nls.builtins.formatting.rustfmt.with {
  --     --       extra_args = function(params)
  --     --         local Path = require "plenary.path"
  --     --         local cargo_toml = Path:new(params.root .. "/" .. "Cargo.toml")
  --     --
  --     --         if cargo_toml:exists() and cargo_toml:is_file() then
  --     --           for _, line in ipairs(cargo_toml:readlines()) do
  --     --             local edition = line:match [[^edition%s*=%s*%"(%d+)%"]]
  --     --             if edition then return { "--edition=" .. edition } end
  --     --           end
  --     --         end
  --     --         -- default edition when we don't find `Cargo.toml` or the `edition` in it.
  --     --         return { "--edition=2021" }
  --     --       end,
  --     --     },
  --     --     nls.builtins.formatting.black,
  --     --
  --     --     nls.builtins.code_actions.eslint_d,
  --     --     nls.builtins.diagnostics.eslint_d,
  --     --     nls.builtins.formatting.eslint_d,
  --     --     nls.builtins.diagnostics.markdownlint,
  --     --     require "nu-ls",
  --     --   },
  --     -- }
  --     -- TODO: on_attach of null-ls don't work
  --     lsp_attach()
  --     vim.cmd "map <Leader>gg :lua vim.lsp.buf.format({timeout_ms = 2000})<CR>"
  --     vim.keymap.set("n", "<leader>go", "<cmd>lua vim.lsp.buf.code_action()<CR>")
  --   end,
  -- },
  {
    "zioroboco/nu-ls.nvim",
    ft = "nu",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "jose-elias-alvarez/null-ls.nvim",
      "jay-babu/mason-null-ls.nvim",
    },
    config = function()
      require("null-ls").setup {
        sources = { require "nu-ls" },
      }
    end,
  },
  {
    "LhKipp/nvim-nu",
    lazy = false,
  },
}
