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
              --     on_attach = function(client, bufnr)
              --       local function keymap(lhs, rhs, opts, mode)
              --         opts = type(opts) == 'string' and { desc = opts }
              --           or vim.tbl_extend('error', opts --[[@as table]], { buffer = bufnr })
              --         mode = mode or 'n'
              --         map(mode, lhs, rhs, opts)
              --       end
              --
              --       ---For replacing certain <C-x>... keymaps.
              --       ---@param keys string
              --       local function feed(keys)
              --         api.nvim_feedkeys(api.nvim_replace_termcodes(keys, true, false, true), 'n', true)
              --       end
              --
              --       ---Is the completion menu open?
              --       local function pumvisible() return tonumber(vim.fn.pumvisible()) ~= 0 end
              --
              --       -- Enable completion and configure keybindings.
              --       if client.supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
              --         vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
              --         print(client.id)
              --         print(bufnr)
              --         keymap(
              --           '<cr>',
              --           function() return pumvisible() and '<C-y>' or '<cr>' end,
              --           { expr = true },
              --           'i'
              --         )
              --
              --         -- Use slash to dismiss the completion menu.
              --         keymap(
              --           '/',
              --           function() return pumvisible() and '<C-e>' or '/' end,
              --           { expr = true },
              --           'i'
              --         )
              --
              --         -- Use <C-n> to navigate to the next completion or:
              --         -- - Trigger LSP completion.
              --         -- - If there's no one, fallback to vanilla omnifunc.
              --         keymap('<C-n>', function()
              --           if pumvisible() then
              --             feed '<C-n>'
              --           else
              --             if next(vim.lsp.get_clients { bufnr = 0 }) then
              --               vim.lsp.completion.trigger()
              --             else
              --               if vim.bo.omnifunc == '' then
              --                 feed '<C-x><C-n>'
              --               else
              --                 feed '<C-x><C-o>'
              --               end
              --             end
              --           end
              --         end, 'Trigger/select next completion', 'i')
              --
              --         -- Buffer completions.
              --         keymap('<C-u>', '<C-x><C-n>', { desc = 'Buffer completions' }, 'i')
              --
              --         -- Use <Tab> to accept a Copilot suggestion, navigate between snippet tabstops,
              --         -- or select the next completion.
              --         -- Do something similar with <S-Tab>.
              --         keymap('<Tab>', function()
              --           local copilot = require 'copilot.suggestion'
              --
              --           if copilot.is_visible() then
              --             copilot.accept()
              --           elseif pumvisible() then
              --             feed '<C-n>'
              --           elseif vim.snippet.active { direction = 1 } then
              --             vim.snippet.jump(1)
              --           else
              --             feed '<Tab>'
              --           end
              --         end, {}, { 'i', 's' })
              --         keymap('<S-Tab>', function()
              --           if pumvisible() then
              --             feed '<C-p>'
              --           elseif vim.snippet.active { direction = -1 } then
              --             vim.snippet.jump(-1)
              --           else
              --             feed '<S-Tab>'
              --           end
              --         end, {}, { 'i', 's' })
              --
              --         -- Inside a snippet, use backspace to remove the placeholder.
              --         keymap('<BS>', '<C-o>s', {}, 's')
              --       end
              --     end,
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
          -- FIXME: weird hang
          pyright = function()
            lspconfig.pyright.setup {
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
              on_attach = function(client, _)
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
    cmd = 'ConformInfo',
    opts = {
      formatters_by_ft = {
        fish = { 'fish_indent', '--only-indent' },
        lua = { 'stylua' },
        python = { 'isort', 'black' },
        sh = { 'shfmt' },
        xml = { 'xmlformat' },

        -- note: for arch, need `perl-unicode-linebreak` as extra dependency
        -- TODO: force a `:retab` for formatter use tab only...
        tex = { 'latexindent', '--GCString' },
        bib = { 'bibtex-tidy' },

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

  -- lsp-rename, but verbose show
  {
    'smjonas/inc-rename.nvim',
    cond = false,
    cmd = 'IncRename',
    opts = {
      -- input_buffer_type = "dressing",
      post_hook = function() fn.histdel('cmd', '^IncRename ') end,
    },
  },

  { 'folke/neodev.nvim', cond = false, ft = 'lua', opts = {} }, -- buggy
  -- { 'folke/lazydev.nvim', ft = 'lua', opts = true },

  -- { 'Bilal2453/luvit-meta', lazy = true },
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
}
