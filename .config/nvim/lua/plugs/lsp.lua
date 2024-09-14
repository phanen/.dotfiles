return {
  {
    'williamboman/mason.nvim',
    build = ':MasonUpdate',
    cmd = 'Mason',
    opts = { ui = { height = 0.85, border = vim.g.border } },
  },
  {
    'williamboman/mason-lspconfig.nvim',
    cmd = { 'LspInstall', 'LspUninstall' },
    opts = {},
  },
  {
    'neovim/nvim-lspconfig',
    lazy = false,
    -- cmd = 'LspInfo',
    -- event = 'FileType',
    config = function()
      -- lspconfig define FileType autocmd, so don't use it in ftplugin
      -- ensure mason path is prepended to PATH
      local l = require('lspconfig')
      -- u.lsp.make_capabilities
      l.lua_ls.setup {
        -- cmd = { vim.fs.normalize '~/b/lua-language-server/build/bin/lua-language-server' },
        -- on_attach = function(client, _) client.server_capabilities.semanticTokensProvider = nil end,
        settings = {
          Lua = {
            hint = { enable = true, setType = true },
            completion = {
              callSnippet = 'Replace',
              -- postfix = '.', -- TODO: not work (a:xx/ string.method)
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

      l.clangd.setup {
        cmd = { 'clangd', '--background-index', '--clang-tidy', '--header-insertion=iwyu' },
      }

      l.pyright.setup {
        -- cmd = { "delance-langserver", "--stdio" },
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = 'openFilesOnly',
            },
          },
        },
      }

      l.gopls.setup {
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

      l.volar.setup {
        on_attach = function(client, _)
          client.server_capabilities.documentFormattingProvider = false
        end,
      }
    end,
  },
}
