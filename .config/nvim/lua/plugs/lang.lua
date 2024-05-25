return {
  { 'HiPhish/info.vim', cond = false, cmd = 'Info' },
  { 'fladson/vim-kitty', ft = 'kitty' },
  { 'chrisbra/csv.vim', ft = 'csv' },
  { 'kmonad/kmonad-vim', ft = 'kbd' },
  -- { 'kovetskiy/sxhkd-vim', event = 'BufReadPre sxhkdrc' }, -- buggy
  { 'baskerville/vim-sxhkdrc', event = 'BufReadPre sxhkdrc' },
  { 'Fymyte/rasi.vim', ft = 'rasi' },
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function() fn['mkdp#util#install']() end,
  },
  { 'mrjones2014/lua-gf.nvim', cond = true, ft = 'lua' },
  {
    'mfussenegger/nvim-jdtls',
    ft = 'java',
    -- event = { 'BufRead *.java', 'BufNewFile *.java' },
    config = function()
      local jdtls = require 'jdtls'
      local mason = require 'mason-registry'
      local capabilities = require 'capabilities'

      local opts = {
        cmd = { vim.fs.joinpath(mason.get_package('jdtls'):get_install_path(), '/bin/jdtls') },
        handlers = {
          ['language/status'] = function() end,
        },
        settings = {
          java = {
            inlayHints = {
              parameterNames = {
                enabled = 'all',
              },
            },
          },
        },
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          jdtls.setup_dap { hotcodereplace = 'auto' }
          require('jdtls.setup').add_commands()
        end,
        init_options = {
          bundles = {
            fn.glob(
              vim.fs.joinpath(
                mason.get_package('java-debug-adapter'):get_install_path(),
                'extension/server/com.microsoft.java.debug.plugin-*.jar'
              ),
              1
            ),
          },
        },
      }

      au('FileType', {
        pattern = 'java',
        desc = 'Attach jdtls',
        callback = function()
          jdtls.start_or_attach(opts)
          vim.bo.tabstop = 4
        end,
      })
    end,
  },

  -- http
  {
    {
      'vhyrro/luarocks.nvim',
      priority = 1000,
      cond = false,
      config = true,
    },
    {
      'rest-nvim/rest.nvim',
      cond = false,
      ft = 'http',
      dependencies = { 'luarocks.nvim' },
      config = function() require('rest-nvim').setup() end,
    },
    {
      'wet-sandwich/hyper.nvim',
      cond = false,
      keys = {
        { ' hy', [[<cmd>lua require('hyper.view').show()<cr>]] },
      },
      tag = '0.1.3',
      dependencies = { 'nvim-lua/plenary.nvim' },
      -- opts = {},
    },
  },

  -- rust
  {
    'saecki/crates.nvim',
    event = { 'BufRead Cargo.toml' },
    config = function()
      require('crates').setup()
      local crates = require 'crates'
      local opts = { silent = true }

      n('+ct', crates.toggle, opts)
      n('+cr', crates.reload, opts)

      n('+cv', crates.show_versions_popup, opts)
      n('+cf', crates.show_features_popup, opts)
      n('+cd', crates.show_dependencies_popup, opts)

      -- n('+cu', crates.update_crate, opts)
      -- vim.keymap.set('v', '+cu', crates.update_crates, opts)
      -- n('+ca', crates.update_all_crates, opts)
      -- n('+cU', crates.upgrade_crate, opts)
      -- vim.keymap.set('v', '+cU', crates.upgrade_crates, opts)
      -- n('+cA', crates.upgrade_all_crates, opts)

      n('+cx', crates.expand_plain_crate_to_inline_table, opts)
      n('+cX', crates.extract_crate_into_table, opts)

      n('+cH', crates.open_homepage, opts)
      n('+cR', crates.open_repository, opts)
      n('+cD', crates.open_documentation, opts)
      n('+cC', crates.open_crates_io, opts)
    end,
  },
  {
    'mrcjkb/rustaceanvim',
    ft = { 'rust' },
    config = function()
      vim.g.rustaceanvim = function()
        return {
          dap = {
            adapter = {
              type = 'server',
              port = '${port}',
              host = '127.0.0.1',
              executable = {
                command = 'codelldb',
                args = {
                  '--port',
                  '${port}',
                  '--settings',
                  vim.json.encode { showDisassembly = 'never' },
                },
              },
            },
          },
        }
      end
    end,
  },
}
