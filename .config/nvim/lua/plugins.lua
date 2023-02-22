local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
  vim.cmd [[packadd packer.nvim]]
end

require('packer').startup(function(use)

  use {
    'wbthomason/packer.nvim'
  }

  use { -- lsp
    'neovim/nvim-lspconfig',
    requires = {
      -- automatically install lsps to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      -- useful status updates for lsp
      'j-hui/fidget.nvim',
      -- additional lua configuration, makes nvim stuff amazing
      'folke/neodev.nvim',
    },
  }

  use { -- autocompletion
    'hrsh7th/nvim-cmp',
    requires = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
  }

  use 'L3MON4D3/LuaSnip'

  use { -- highlight, edit, navigation
    'nvim-treesitter/nvim-treesitter',
    run = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  }

  use { -- additional text objects via treesitter
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = 'nvim-treesitter',
  }

  -- git
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'
  use 'lewis6991/gitsigns.nvim'

  -- theme
  use 'navarasu/onedark.nvim'
  use 'folke/tokyonight.nvim'
  -- use 'rose-pine/neovim'

  -- file management
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },
    tag = 'nightly' -- optional, updated every week. (see issue #1193)
  }

  use {"akinsho/toggleterm.nvim", tag = '*', config = function()
    require("toggleterm").setup()
  end}
  use {
    'akinsho/bufferline.nvim', tag = "v3.*", requires = 'nvim-tree/nvim-web-devicons',
    config = function()

    end
  }

  use 'nvim-lualine/lualine.nvim' -- statusline

  use 'lukas-reineke/indent-blankline.nvim' -- add indentation guides even on blank lines

  use 'numToStr/Comment.nvim'

  use 'tpope/vim-sleuth' -- Detect tabstop and shiftwidth automatically

  -- fuzzy finder files, lsp, etc
  use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } }

  -- fuzzy finder algorithm which requires local dependencies to be built. only load if `make` is available
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable 'make' == 1 }


  -- markdown
  -- use 'davidgranstrom/nvim-markdown-preview' -- based on floated pacdoc
  use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install", setup = function() vim.g.mkdp_filetypes = { "markdown" } end, ft = { "markdown" }, })

  use ({
    'askfiy/nvim-picgo',
    config = function()
      -- it doesn't require you to do any configuration
      require("nvim-picgo").setup()
    end
  })


  -- edit
  use({ "linty-org/readline.nvim"})
  use({ "kylechui/nvim-surround",
    tag = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
      require("nvim-surround").setup({
      })
    end
  })

  -- game
  use({ "alec-gibson/nvim-tetris"})

  -- latex
  use({
    'f3fora/nvim-texlabconfig',
    config = function()
      require('texlabconfig').setup()
    end,
    ft = { 'tex', 'bib' }, -- for lazy loading
    run = 'go build'
    -- run = 'go build -o ~/.bin/' if e.g. ~/.bin/ is in $PATH
  })

  use { "karb94/neoscroll.nvim" }

  -- TODO
  -- better markdown 
  use({'jakewvincent/mkdnflow.nvim',
    config = function()
      require('mkdnflow').setup({
        -- Config goes here; leave blank for defaults
      })
    end
  })

  use('crispgm/telescope-heading.nvim')

  use {
    "smjonas/inc-rename.nvim",
    config = function()
      require("inc_rename").setup()
    end,
  }

    use {
      'stevearc/aerial.nvim',
      config = function() require('aerial').setup() end
    }

  if is_bootstrap then
    require('packer').sync()
    print '=================================='
    print '    Plugins are being installed'
    print '    Wait until Packer completes,'
    print '       then restart nvim'
    print '=================================='
    return
  end
end)

require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'auto',
    component_separators = '|',
    section_separators = '',
  },
}

require('indent_blankline').setup {
  char = '┊',
  show_trailing_blankline_indent = false,
}

-- gitsigns
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}

require('Comment').setup()

-- LSP settings
local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

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

  -- See `:help K` for why this keymap
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

-- setup neovim lua configuration
require('neodev').setup()
-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local executable = 'zathura'
local args = {
  '--synctex-editor-command',
  [[nvim-texlabconfig -file '%{input}' -line %{line}]],
  '--synctex-forward',
  '%l:1:%f',
  '%p',
}

local servers = {
  -- clangd = {},
  gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  -- tsserver = {},
  texlab = {
    texlab = {
      forwardSearch = {
        executable = executable,
        args = args,
      }
    }
  },
  -- sumneko_lua = {
  --   Lua = {
  --     workspace = { checkThirdParty = false },
  --     telemetry = { enable = false },
  --   },
  -- },
}

-- setup mason so it can manage external tooling
require('mason').setup()

local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup { -- ensure the servers above are installed
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,

  -- ["texlab"] = function ()
  --   require('lspconfig').texlab.setup({
  -- end
  --   })
  -- ["marksman"] = function()
  --   require('lspconfig').marksman.setup {
  --     on_attach = on_attach,
  --     capabilities = capabilities,
  --     cmd = { 'marksman', 'server' },
  --     filetypes = { 'markdown' },
  --     single_file_support = false,
  --     flags = {
  --       debounce_text_changes = 150
  --     }
  --   }
  -- end,
}


-- core API
-- LaunchMarksman = function()
--   local client_id = vim.lsp.start_client({cmd = {"marksman", "server"}})
--   vim.lsp.buf_attach_client(0, client_id)
--   local client = vim.lsp.get_client_by_id(client_id)
--
-- end
--
-- vim.cmd([[
--   command! -range LaunchMarksman  execute 'lua LaunchMarksman()'
-- ]])

-- require('lspconfig').marksman.setup{
--   on_attach=on_attach
-- }

-- require('lspconfig').gopls.setup{
--   on_attach=on_attach,
-- }
--
--
-- require('lspconfig').sumneko_lua.setup{
--   on_attach=on_attach,
--   -- capabilities=capabilities,
-- }

-- turn on lsp status information
require('fidget').setup()

-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<c-d>'] = cmp.mapping.scroll_docs(-4),
    ['<c-f>'] = cmp.mapping.scroll_docs(4),
    ['<c-space>'] = cmp.mapping.complete(),
    ['<cr>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<s-tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}
