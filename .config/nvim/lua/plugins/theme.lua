return {
  { "EdenEast/nightfox.nvim",     lazy = false },
  { "NLKNguyen/papercolor-theme", lazy = false },
  { "igorgue/danger",             lazy = false },
  { "rebelot/kanagawa.nvim",      lazy = false },
  { "folke/tokyonight.nvim",      lazy = false },
  { "navarasu/onedark.nvim",      lazy = false },
  { "shaunsingh/nord.nvim",       lazy = false },
  { "AlexvZyl/nordic.nvim",       lazy = false },
  { "rose-pine/neovim",           name = "rose-pine", lazy = false },
  { "Mofiqul/dracula.nvim",       lazy = false },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    -- opts = { transparent_background = true },
  },
  --
  -- {
  --   "mcchrish/zenbones.nvim",
  --   lazy = false,
  --   -- Optionally install Lush. Allows for more configuration or extending the colorscheme
  --   -- If you don't want to install lush, make sure to set g:zenbones_compat = 1
  --   -- In Vim, compat mode is turned on as Lush only works in Neovim.
  --   dependencies = "rktjmp/lush.nvim"
  -- },
  --
  -- { "mswift42/vim-themes", lazy = false, },
  --
  -- {
  --   "NTBBloodbath/doom-one.nvim",
  --   lazy = false,
  --   config = function()
  --     vim.g.doom_one_pumblend_enable = true
  --     vim.g.doom_one_pumblend_transparency = 3
  --   end,
  -- },
  --
  -- -- funcy
  -- {
  --   "xiyaowong/transparent.nvim",
  --   lazy = false,
  --   cond = false,
  --   priority = 1000,
  --   config = function()
  --     require("transparent").setup {
  --       groups = { -- table: default groups
  --         "Normal",
  --         "NormalNC",
  --         "Comment",
  --         "Constant",
  --         "Special",
  --         "Identifier",
  --         "Statement",
  --         "PreProc",
  --         "Type",
  --         "Underlined",
  --         "Todo",
  --         "String",
  --         "Function",
  --         "Conditional",
  --         "Repeat",
  --         "Operator",
  --         "Structure",
  --         "LineNr",
  --         "NonText",
  --         "SignColumn",
  --         "CursorLineNr",
  --         "EndOfBuffer",
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
  --         "NvimTreeNormal",
  --       },
  --       exclude_groups = {}, -- table: groups you don't want to clear
  --     }
  --   end,
  -- },
}
