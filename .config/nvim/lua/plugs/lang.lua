return {
  { 'HiPhish/info.vim', cond = false, cmd = 'Info' },
  { 'fladson/vim-kitty', ft = 'kitty' },
  { 'chrisbra/csv.vim', ft = 'csv' },
  { 'kmonad/kmonad-vim', ft = 'kbd' },
  -- { 'kovetskiy/sxhkd-vim', event = 'BufReadPre sxhkdrc' }, -- buggy
  { 'baskerville/vim-sxhkdrc', event = 'BufReadPre sxhkdrc' },

  {
    'NoahTheDuke/vim-just',
    ft = { 'just' },
  },
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
      local ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
      -- local capabilities = require 'capabilities'
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      if ok then
        capabilities =
          vim.tbl_deep_extend('force', capabilities, cmp_nvim_lsp.default_capabilities())
      end

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
    'rest-nvim/rest.nvim',
    cond = false,
    ft = 'http',
    main = 'rest-nvim',
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

  -- rust
  {
    'saecki/crates.nvim',
    event = { 'BufRead Cargo.toml' },
    config = function()
      require('crates').setup()
      local crates = require 'crates'

      n('+ct', crates.toggle)
      n('+cr', crates.reload)
      n('+cv', crates.show_versions_popup)
      n('+cf', crates.show_features_popup)
      n('+cd', crates.show_dependencies_popup)
      -- n('+cu', crates.update_crate)
      -- vim.keymap.set('v', '+cu', crates.update_crates)
      -- n('+ca', crates.update_all_crates)
      -- n('+cU', crates.upgrade_crate)
      -- vim.keymap.set('v', '+cU', crates.upgrade_crates)
      -- n('+cA', crates.upgrade_all_crates)
      n('+cx', crates.expand_plain_crate_to_inline_table)
      n('+cX', crates.extract_crate_into_table)
      n('+cH', crates.open_homepage)
      n('+cR', crates.open_repository)
      n('+cD', crates.open_documentation)
      n('+cC', crates.open_crates_io)
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
  {
    'psliwka/vim-dirtytalk',
    build = ':DirtytalkUpdate',
    config = function() vim.opt.spelllang = { 'en', 'programming' } end,
  },
}
