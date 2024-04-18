return {
  {
    'j-hui/fidget.nvim',
    event = 'LspAttach',
    opts = {
      notification = { poll_rate = 2, override_vim_notify = false },
      integration = { ['nvim-tree'] = { enable = false } },
    },
  },
  {
    'williamboman/mason-lspconfig.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      {
        'williamboman/mason.nvim',
        build = ':MasonUpdate',
        cmd = 'Mason',
        opts = { ui = { height = 0.85, border = vim.g.border } },
      },
      {
        'neovim/nvim-lspconfig',
        cmd = { 'LspInfo', 'LspInstall', 'LspUninstall' },
        config = function() require('lspconfig.ui.windows').default_options.border = vim.g.border end,
      },
    },
    config = function()
      local lspconfig = require 'lspconfig'
      local ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      if ok then
        capabilities =
          vim.tbl_deep_extend('force', capabilities, cmp_nvim_lsp.default_capabilities())
      end
      require('mason-lspconfig').setup {
        handlers = {
          function(server) lspconfig[server].setup { capabilities = capabilities } end,
          lua_ls = function()
            lspconfig.lua_ls.setup {
              -- on_attach = function(client)
              -- disable treesitter highlight if has semantic highlight
              -- vim.print(client)
              -- if client.server_capabilities.semanticTokensProvider then
              --   vim.cmd.TSDisable('highlight')
              -- end
              -- end,
              capabilities = capabilities,
              settings = {
                Lua = {
                  hint = { enable = true, setType = true },
                  completion = {
                    callSnippet = 'Replace',
                    postfix = '.',
                    showWord = 'Disable',
                    workspaceWord = false,
                  },
                  format = {
                    defaultConfig = {
                      call_arg_parentheses = 'remove_table_only',
                      add_comma = 'comma',
                    },
                  },
                  runtime = { version = 'LuaJIT' },
                },
              },
            }
          end,
          clangd = function()
            lspconfig.clangd.setup {
              capabilities = capabilities,
              cmd = { 'clangd', '--background-index', '--clang-tidy', '--header-insertion=iwyu' },
              root_dir = lspconfig.util.root_pattern(
                'compile_commands.json',
                'compile_flags.txt',
                '.git'
              ),
            }
          end,
          gopls = function()
            lspconfig.gopls.setup {
              settings = {
                gopls = {
                  hints = {
                    assignVariableTypes = true,
                    compositeLiteralFields = true,
                    compositeLiteralTypes = true,
                    constantValues = true,
                    functionTypeParameters = true,
                    parameterNames = true,
                    rangeVariableTypes = true,
                  },
                },
              },
            }
          end,
          rust_analyzer = function() end,
          volar = function()
            lspconfig.volar.setup {
              on_attach = function(client, bufnr)
                client.server_capabilities.documentFormattingProvider = false
              end,
              capabilities = capabilities,
            }
          end,
        },
      }
    end,
  },
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        fish = { 'fish_indent' },
        lua = { 'stylua' },
        python = { 'isort', 'black' },
        sh = { 'shfmt' },

        css = { 'prettier' },
        html = { 'prettier' },
        javascript = { 'prettier' },
        javascriptreact = { 'prettier' },
        json = { 'prettier' },
        less = { 'prettier' },
        scss = { 'prettier' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
        vue = { 'prettier' },
        yaml = { 'prettier' },
      },
      formatters = {
        shfmt = {
          command = 'shfmt',
          args = { '-i', '2', '-filename', '$FILENAME' },
        },
      },
    },
  },
}
