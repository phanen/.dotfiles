return {
  { 'HiPhish/info.vim', cmd = 'Info' },
  { 'fladson/vim-kitty', ft = 'kitty' },
  { 'chrisbra/csv.vim', ft = 'csv' },
  { 'kmonad/kmonad-vim', ft = 'kbd' },
  -- { 'kovetskiy/sxhkd-vim', event = 'BufReadPre sxhkdrc' }, -- buggy
  { 'baskerville/vim-sxhkdrc', event = 'BufReadPre sxhkdrc' },

  { 'NoahTheDuke/vim-just', ft = { 'just' } },
  { 'Fymyte/rasi.vim', ft = 'rasi' },
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function() fn['mkdp#util#install']() end,
  },
  {
    'mfussenegger/nvim-jdtls',
    ft = 'java',
    -- event = { 'BufRead *.java', 'BufNewFile *.java' },
    config = function()
      local jdtls = require 'jdtls'
      local mason = require 'mason-registry'

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
        capabilities = u.lsp.make_capabilities(),
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

      jdtls.start_or_attach(opts)
    end,
  },

  -- rust
  {
    'saecki/crates.nvim',
    event = { 'BufRead Cargo.toml' },
    config = function()
      require('crates').setup()
      local crates = require 'crates'
      map.n[0]('+ct', crates.toggle)
      map.n[0]('+cr', crates.reload)
      map.n[0]('+cv', crates.show_versions_popup)
      map.n[0]('+cf', crates.show_features_popup)
      map.n[0]('+cd', crates.show_dependencies_popup)
      map.n[0]('+cu', crates.update_crate)
      map.n[0]('+ca', crates.update_all_crates)
      map.n[0]('+cU', crates.upgrade_crate)
      map.n[0]('+cA', crates.upgrade_all_crates)
      map.n[0]('+cx', crates.expand_plain_crate_to_inline_table)
      map.n[0]('+cX', crates.extract_crate_into_table)
      map.n[0]('+cH', crates.open_homepage)
      map.n[0]('+cR', crates.open_repository)
      map.n[0]('+cD', crates.open_documentation)
      map.n[0]('+cC', crates.open_crates_io)
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
