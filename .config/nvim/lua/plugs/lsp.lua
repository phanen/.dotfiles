return {
  {
    'j-hui/fidget.nvim',
    event = 'LspAttach',
    opts = {
      notification = { poll_rate = 10, override_vim_notify = false },
      progress = { poll_rate = 0 },
      integration = { ['nvim-tree'] = { enable = false } },
    },
  },
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
    cmd = { 'LspInfo' },
    event = 'FileType',
    config = function()
      -- lspconfig define FileType autocmd, so don't use it in ftplugin
      -- mason path should be prepended to PATH
      local l = require('lspconfig')
      -- u.lsp.make_capabilities
      l.lua_ls.setup {
        -- cmd = { vim.fs.normalize '~/b/lua-language-server/build/bin/lua-language-server' },
        -- on_attach = function(client) client.server_capabilities.semanticTokensProvider = nil end,
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
        -- TODO: forback?
        -- c = { 'uncrustify_nvim', 'clang-format' },
        c = { 'uncrustify_nvim' },

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
        uncrustify_nvim = {
          command = g.nvim_root .. '/build/usr/bin/uncrustify',
          args = function()
            if u.git.root() == g.nvim_root then
              local cfg = g.nvim_root .. '/src/uncrustify.cfg'
              return { '-q', '-l', 'C', '-c', cfg }
            end
          end,
        },
      },
    },
  },
  {
    'ray-x/lsp_signature.nvim',
    cond = false,
    event = 'LspAttach',
    opts = {
      hint_prefix = '🧐 ',
      handler_opts = { border = 'rounded' },
    },
  },

  { 'folke/neodev.nvim', cond = false, ft = 'lua', opts = {} }, -- buggy
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    cond = true,
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
