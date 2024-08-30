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
    'williamboman/mason.nvim',
    build = ':MasonUpdate',
    cmd = 'Mason',
    opts = {
      -- PATH = 'append',
      ui = { height = 0.85, border = vim.g.border },
    },
  },
  -- TODO: restart nvim but not lsp (.....overhead)
  {
    'neovim/nvim-lspconfig',
    cmd = { 'LspInfo', 'LspInstall', 'LspUninstall' },
    config = function() require('lspconfig.ui.windows').default_options.border = vim.g.border end,
  },
  {
    'williamboman/mason-lspconfig.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lspconfig = require 'lspconfig'
      local ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      if ok then
        capabilities =
          vim.tbl_deep_extend('force', capabilities, cmp_nvim_lsp.default_capabilities())
      end

      -- put it here, or put it in ftplugin
      -- lspconfig.lua_ls.setup {
      --   -- cmd = { vim.fs.normalize '~/b/lua-language-server/build/bin/lua-language-server' },
      --   cmd = { '/bin/lua-language-server' },
      --   -- cmd = { '/bin/lua-language-server' },
      --   on_attach = function(client) end,
      --   capabilities = capabilities,
      --   settings = {},
      -- }

      require('mason-lspconfig').setup {}
      require('mason-lspconfig').setup_handlers {
        function(server) lspconfig[server].setup { capabilities = capabilities } end,
        rust_analyzer = function() end,
        -- lua_ls = function() end,
        -- TODO: handle workspace change..
        lua_ls = function()
          lspconfig.lua_ls.setup {
            on_attach = function(client)
              -- FIXME: color mess.....

              -- disable semantic highlight
              -- client.server_capabilities.semanticTokensProvider = nil

              -- disable treesitter highlight
              if client.server_capabilities.semanticTokensProvider then
                -- FIXME: this will disable on all filetype....
                -- vim.cmd.TSDisable('highlight')
              end
            end,
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
                diagnostics = {
                  disable = { 'missing-fields', 'incomplete-signature-doc' },
                },
                runtime = { version = 'LuaJIT' },
              },
            },
          }
        end,
        -- FIXME: hang if don't use venv
        pyright = function()
          lspconfig.pyright.setup {
            -- FIXME: to run this (use this command), we must ensure lsp is installed
            cmd = { 'pyright-langserver', '--stdio' },
            capabilities = capabilities,
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
        end,
        -- FIXME: also hang
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
        volar = function()
          lspconfig.volar.setup {
            on_attach = function(client, _)
              client.server_capabilities.documentFormattingProvider = false
            end,
            capabilities = capabilities,
          }
        end,
      }
    end,
  },
  {
    'stevearc/conform.nvim',
    cmd = 'ConformInfo',
    opts = {
      formatters_by_ft = {
        fish = { 'fish_indent', '--only-indent' },
        lua = { 'stylua' },
        python = { 'ruff' },
        sh = { 'shfmt' },
        xml = { 'xmlformat' },
        toml = { 'taplo' },
        c = { 'uncrustify' },

        -- note: for arch, need `perl-unicode-linebreak` as extra dependency
        -- TODO: force a `:retab` for formatter use tab only...
        tex = { 'latexindent', '--GCString' },
        bib = { 'bibtex-tidy' },

        css = { 'prettier' },
        html = { 'prettier' },
        javascript = { 'prettier' },
        javascriptreact = { 'prettier' },
        -- json = { 'prettier' }, -- not work?
        json = { 'clang-format' },
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
        uncrustify_neovim = {
          command = env.HOME .. 'b/neovim/build/bin/uncrustify',
          args = { '-q', '-l', 'C', '-c', '$CONFIG' },
        },
      },
    },
  },

  -- never find it useful now
  {
    'ray-x/lsp_signature.nvim',
    cond = false,
    event = 'LspAttach',
    opts = {
      hint_prefix = '🧐 ',
      handler_opts = { boarder = 'rounded' },
    },
  },

  { 'folke/neodev.nvim', cond = false, ft = 'lua', opts = {} }, -- buggy
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      -- FIXME: not work
      library = {
        -- { path = 'luvit-meta/library', words = { 'vim%.uv' } },
        { 'luvit-meta/library' },
      },
      enabled = function(root_dir)
        -- NOTE: in this way we also don't lazy load .dotfile now (since we've used global notations in `set.lua`)
        return not uv.fs_stat(root_dir .. '/.luarc.jsonc')
          and not uv.fs_stat(root_dir .. '/.luarc.json')
      end,
    },
  },
  { 'Bilal2453/luvit-meta', lazy = true },
  -- { -- optional completion source for require statements and module annotations
  --   'hrsh7th/nvim-cmp',
  --   opts = function(_, opts)
  --     opts.sources = opts.sources or {}
  --     table.insert(opts.sources, {
  --       name = 'lazydev',
  --       group_index = 0, -- set group index to 0 to skip loading LuaLS completions
  --     })
  --   end,
  -- },
  {
    'mfussenegger/nvim-lint',
    cond = false,
    config = function()
      require('lint').linters_by_ft = {
        python = { 'pylint' },
      }
      autocmd({
        'BufReadPost',
        'BufWritePost',
        'InsertLeave',
      }, {
        desc = 'Lint',
        callback = function() require('lint').try_lint() end,
      })
    end,
  },
}
