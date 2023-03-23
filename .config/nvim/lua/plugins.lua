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
  {
    'jose-elias-alvarez/null-ls.nvim',
    config = function()
      -- local null_ls = require("null-ls")
      -- null_ls.setup({
      --   sources = {
      --     -- null_ls.builtins.diagnostics.cspell,
      --     -- null_ls.builtins.code_actions.cspell,
      --     null_ls.builtins.formatting.stylua,
      --     null_ls.builtins.diagnostics.eslint,
      --     null_ls.builtins.completion.spell,
      --   },
      -- })
    end,
  },
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
    dependencies = { 'nvim-lua/plenary.nvim' }
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

  -- { -- cmdline
  --   "folke/noice.nvim",
  --   config = function() require("noice").setup({}) end,
  --   dependencies = {
  --     -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
  --     "MunifTanjim/nui.nvim",
  --     -- OPTIONAL:
  --     --   `nvim-notify` is only needed, if you want to use the notification view.
  --     --   If not available, we use `mini` as the fallback
  --     "rcarriga/nvim-notify",
  --   }
  -- },
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
  {
    "catppuccin/nvim", name = "catppuccin",
    config = function()
      require('catppuccin').setup{
        transparent_background = true,
      }
    end,
  },
  -- funcy
  -- {
  --   'xiyaowong/transparent.nvim',
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("transparent").setup({
  --       groups = { -- table: default groups
  --         'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
  --         'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
  --         'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
  --         'SignColumn', 'CursorLineNr', 'EndOfBuffer' 
  --       },
  --       extra_groups = { -- table/string: additional groups that should be cleared
  --         -- In particular, when you set it to 'all', that means all available groups
  --
  --         -- example of akinsho/nvim-bufferline.lua
  --         "BufferLineTabClose",
  --         "BufferlineBufferSelected",
  --         "BufferLineFill",
  --         "BufferLineBackground",
  --         "BufferLineSeparator",
  --         "BufferLineIndicatorSelected",
  --         'NvimTreeNormal',
  --       },
  --       exclude_groups = {}, -- table: groups you don't want to clear
  --     })
  --   end,
  -- },

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
  -- disgnose
  {
    "folke/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function() require("trouble").setup {} end
  },
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
  hijack_netrw = true,
})


-- local setup, nvimtree = pcall(require, "nvim-tree")
-- if not setup then return end
--
-- vim.cmd([[
--   nnoremap - :NvimTreeToggle<CR>
-- ]])
--
-- -- local keymap = vim.keymap -- for conciseness
-- -- keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>") -- toggle file explorer
--
-- -- vim.opt.foldmethod = "expr"
-- -- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- -- vim.opt.foldenable = false --                  " Disable folding at startup.
--
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1
--
-- vim.opt.termguicolors = true
--
-- local HEIGHT_RATIO = 0.8 -- You can change this
-- local WIDTH_RATIO = 0.5  -- You can change this too
--
-- nvimtree.setup({
--   disable_netrw = true,
--   hijack_netrw = true,
--   respect_buf_cwd = true,
--   sync_root_with_cwd = true,
--   view = {
--     relativenumber = true,
--     float = {
--       enable = true,
--       open_win_config = function()
--         local screen_w = vim.opt.columns:get()
--         local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
--         local window_w = screen_w * WIDTH_RATIO
--         local window_h = screen_h * HEIGHT_RATIO
--         local window_w_int = math.floor(window_w)
--         local window_h_int = math.floor(window_h)
--         local center_x = (screen_w - window_w) / 2
--         local center_y = ((vim.opt.lines:get() - window_h) / 2)
--                          - vim.opt.cmdheight:get()
--         return {
--           border = "rounded",
--           relative = "editor",
--           row = center_y,
--           col = center_x,
--           width = window_w_int,
--           height = window_h_int,
--         }
--         end,
--     },
--     width = function()
--       return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
--     end,
--   },
--   -- filters = {
--   --   custom = { "^.git$" },
--   -- },
--   -- renderer = {
--   --   indent_width = 1,
--   -- },
-- })
