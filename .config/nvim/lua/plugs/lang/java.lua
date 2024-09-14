return {
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
}
