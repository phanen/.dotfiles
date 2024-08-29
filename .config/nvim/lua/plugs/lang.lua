return {
  { 'HiPhish/info.vim', cond = false, cmd = 'Info' },
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

      autocmd('FileType', {
        pattern = 'java',
        desc = 'Attach jdtls',
        callback = function()
          jdtls.start_or_attach(opts)
          vim.bo.tabstop = 4
        end,
      })
    end,
  },

  -- rust
  {
    'saecki/crates.nvim',
    event = { 'BufRead Cargo.toml' },
    config = function()
      require('crates').setup()
      local crates = require 'crates'

      map.n('+ct', crates.toggle)
      map.n('+cr', crates.reload)
      map.n('+cv', crates.show_versions_popup)
      map.n('+cf', crates.show_features_popup)
      map.n('+cd', crates.show_dependencies_popup)
      -- n('+cu', crates.update_crate)
      -- vim.keymap.set('v', '+cu', crates.update_crates)
      -- n('+ca', crates.update_all_crates)
      -- n('+cU', crates.upgrade_crate)
      -- vim.keymap.set('v', '+cU', crates.upgrade_crates)
      -- n('+cA', crates.upgrade_all_crates)
      map.n('+cx', crates.expand_plain_crate_to_inline_table)
      map.n('+cX', crates.extract_crate_into_table)
      map.n('+cH', crates.open_homepage)
      map.n('+cR', crates.open_repository)
      map.n('+cD', crates.open_documentation)
      map.n('+cC', crates.open_crates_io)
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
