local lsp_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then desc = 'LSP: ' .. desc end
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  -- nmap('<c-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local lsp_servers = {
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
  clangd = {},
  rust_analyzer = {},
  gopls = {},
  pyright = {},
  tsserver = {},
}

return {
  { 
    'neovim/nvim-lspconfig',
    dependencies = {
      {
        'folke/neodev.nvim', ft = 'lua',
        opts = { library = { plugins = { 'nvim-dap-ui' } } },
      },
      {
        'folke/neoconf.nvim', cmd = { 'Neoconf' },
        opts = { local_settings = '.nvim.json', global_settings = 'nvim.json' },
      },
    },
  },

  { -- status updates for lsp
    'j-hui/fidget.nvim', 
    lazy = false,
    config = true,
  },

  {
    'williamboman/mason.nvim',
    config = true,
    cmd = "Mason",
    -- opts = { ui = { border = border, height = 0.8 } },
  },

  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'mason.nvim', },

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
