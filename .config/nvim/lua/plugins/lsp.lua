local lsp_attach = require('utils.lsp').lsp_attach
local lsp_servers = require('utils.lsp').lsp_servers
local capabilities = require('utils.lsp').capabilities

return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      {
        'folke/neodev.nvim',
        ft = 'lua',
        opts = { library = { plugins = { 'nvim-dap-ui' } } },
      },
      {
        'folke/neoconf.nvim',
        cmd = { 'Neoconf' },
        opts = { local_settings = '.nvim.json', global_settings = 'nvim.json' },
      },
    },
  },

  -- status updates for lsp
  {
    'j-hui/fidget.nvim',
    lazy = false,
    config = true,
  },

  {
    'williamboman/mason.nvim',
    build = ':MasonUpdate',
    cmd = "Mason",
    config = true,
    -- opts = { ui = { border = border, height = 0.8 } },
  },

  {
    'williamboman/mason-lspconfig.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'williamboman/mason.nvim', },
    config = function()
      local mlsp = require 'mason-lspconfig'
      mlsp.setup { ensure_installed = vim.tbl_keys(lsp_servers), }
      mlsp.setup_handlers {
        function(server_name)
          require('lspconfig')[server_name].setup {
            capabilities = capabilities,
            on_attach = lsp_attach,
            settings = lsp_servers[server_name],
          }
        end,
        -- ['texlab'] = function () require('lspconfig').texlab.setup({ end })
      }
    end,
  },
  -- {
  --   'jose-elias-alvarez/null-ls.nvim',
  --   config = function() end,
  -- },
}
