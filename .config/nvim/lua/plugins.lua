local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system { 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable',
    lazypath, }
end
vim.opt.rtp:prepend(lazypath)

vim.o.completeopt = 'menuone,noselect,noinsert'

require('lazy').setup {

  'folke/lazy.nvim',

  -- lsp
  {
    'neovim/nvim-lspconfig',
    dependencies = { 'folke/neodev.nvim', config = function() require('neodev').setup() end },
  },

  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',
  -- {
  --   "jayp0521/mason-nvim-dap.nvim",
  --   config = function()
  --     require("mason-nvim-dap").setup({
  --       automatic_installation = true,
  --       ensure_installed = { "codelldb" },
  --     })
  --   end,
  -- },

  --
  { -- status updates for lsp
    'j-hui/fidget.nvim', config = function() require('fidget').setup() end,
  },

  -- autocompletion
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lua',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-nvim-lsp-signature-help',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-buffer',
  'L3MON4D3/LuaSnip',
  'saadparwaiz1/cmp_luasnip',

  --lazy
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
  },

  {
    -- highlight, edit, navigation
    'nvim-treesitter/nvim-treesitter',
    build = function() require('nvim-treesitter.install').update { with_sync = true } end,
    dependencies = 'nvim-treesitter/nvim-treesitter-textobjects',
  },


  -- fzf
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.1',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-tree.lua' }
  },

  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    cond = vim.fn.executable 'make' == 1
  },

  'crispgm/telescope-heading.nvim',

  -- functionality
  {
    -- file
    'nvim-tree/nvim-tree.lua',
    lazy = false,
    priority = 1000,
    dependencies = { 'nvim-tree/nvim-web-devicons', },
    tag = 'nightly',
  },

  {
    -- tab
    'akinsho/bufferline.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
  },

  'nvim-lualine/lualine.nvim',           -- statusline
  'lukas-reineke/indent-blankline.nvim', -- hint on indent

  {
    --outline
    'stevearc/aerial.nvim',
    config = function() require('aerial').setup() end
  },

  {
    'akinsho/toggleterm.nvim',
    config = function() require('toggleterm').setup() end,
  },

  -- scroll
  { 'karb94/neoscroll.nvim' },

  -- git
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  'lewis6991/gitsigns.nvim',

  -- theme
  'navarasu/onedark.nvim',
  'folke/tokyonight.nvim',
  'rose-pine/neovim',

  -- edit enhancement
  'linty-org/readline.nvim',
  {
    'kylechui/nvim-surround',
    config = function() require('nvim-surround').setup {} end
  },

  'numToStr/Comment.nvim',
  'tpope/vim-sleuth', -- detect tabstop and shiftwidth automatically

  {
    "windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end,
  },

  {
    -- incremental rename
    'smjonas/inc-rename.nvim',
    config = function()
      require('inc_rename').setup()
    end,
  },

  -- TODO
  -- markdown
  {
    'iamcco/markdown-preview.nvim',
    build = 'cd app && npm install',
    config = function() vim.g.mkdp_filetypes = { 'markdown' } end,
    ft = { 'markdown' },
  },

  {
    'askfiy/nvim-picgo',
    config = function() require('nvim-picgo').setup() end
  },

  {
    'jakewvincent/mkdnflow.nvim',
    config = function()
      require('mkdnflow').setup {
        mappings = {
          MkdnNextHeading = { 'n', ']]' },
          MkdnPrevHeading = { 'n', '[[' },
          MkdnNewListItemBelowInsert = { 'n', 'o' },
          MkdnNewListItemAboveInsert = { 'n', 'O' },
          MkdnCreateLinkFromClipboard = { { 'n', 'v' }, '<leader>p' }, -- see MkdnEnter
          MkdnEnter = false,
          MkdnTab = false,
          MkdnSTab = false,
          MkdnNextLink = false,
          MkdnPrevLink = false,
          MkdnGoBack = { 'n', '<BS>' },
          MkdnGoForward = { 'n', '<Del>' },
          MkdnCreateLink = false,                            -- see MkdnEnter
          MkdnFollowLink = false,                            -- see MkdnEnter
          MkdnDestroyLink = { 'n', '<M-CR>' },
          MkdnTagSpan = { 'v', '<M-CR>' },
          MkdnMoveSource = false,
          MkdnYankAnchorLink = { 'n', 'ya' },
          MkdnYankFileAnchorLink = { 'n', 'yfa' },
          MkdnIncreaseHeading = { 'n', '+' },
          MkdnDecreaseHeading = { 'n', '-' },
          MkdnToggleToDo = { { 'n', 'v' }, '<C-Space>' },
          MkdnNewListItem = false,
          MkdnExtendList = false,
          MkdnUpdateNumbering = { 'n', '<leader>nn' },
          MkdnTableNextCell = { 'i', '<Tab>' },
          MkdnTablePrevCell = { 'i', '<S-Tab>' },
          MkdnTableNextRow = false,
          MkdnTablePrevRow = { 'i', '<M-CR>' },
          MkdnTableNewRowBelow = { 'n', '<leader>ir' },
          MkdnTableNewRowAbove = { 'n', '<leader>iR' },
          MkdnTableNewColAfter = { 'n', '<leader>ic' },
          MkdnTableNewColBefore = { 'n', '<leader>iC' },
          MkdnFoldSection = { 'n', '<leader>f' },
          MkdnUnfoldSection = { 'n', '<leader>F' }
        }
      }
    end
  },

  -- latex
  -- {
  --   'f3fora/nvim-texlabconfig',
  --   config = function() require('texlabconfig').setup() end,
  --   ft = { 'tex', 'bib' }, -- for lazy loading build = 'go build'
  -- },
  -- {'lervag/vimtex'},

  {
    -- math mode snippets
    'iurimateus/luasnip-latex-snippets.nvim',
    branch = 'markdown',
    dependencies = { 'L3MON4D3/LuaSnip', 'lervag/vimtex' },
    config = function()
      require 'luasnip-latex-snippets'.setup({ use_treesitter = true }) --{ use_treesitter = true }
    end,
    ft = { 'tex', 'markdown' },
  },

  -- rust
  'simrat39/rust-tools.nvim',

  -- debug
  'mfussenegger/nvim-dap',
  'rcarriga/nvim-dap-ui',
  {
    "SmiteshP/nvim-navic",
    dependencies = "neovim/nvim-lspconfig"
  },
  'theHamsta/nvim-dap-virtual-text',
  --
  -- game
  'alec-gibson/nvim-tetris',
}


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

require("bufferline").setup {
  options = {
    mode = "tabs",
    numbers = "ordinal",
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        highlight = "Directory",
        text_align = "left"
      }
    }
  }
}

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


require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
      },
    },
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})
