return {

  'navarasu/onedark.nvim',

  'folke/tokyonight.nvim',

  {
    'rose-pine/neovim', name = 'rose-pine',
  },

  {
    'catppuccin/nvim', name = 'catppuccin',
    config = function()
      require('catppuccin').setup{
        transparent_background = true,
      }
    end,
  },

  -- funcy
  {
    'xiyaowong/transparent.nvim',
    cond = false,
    lazy = false,
    priority = 1000,
    config = function()
      require("transparent").setup({
        groups = { -- table: default groups
          'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
          'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
          'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
          'SignColumn', 'CursorLineNr', 'EndOfBuffer'
        },
        extra_groups = { -- table/string: additional groups that should be cleared
          -- In particular, when you set it to 'all', that means all available groups

          -- example of akinsho/nvim-bufferline.lua
          "BufferLineTabClose",
          "BufferlineBufferSelected",
          "BufferLineFill",
          "BufferLineBackground",
          "BufferLineSeparator",
          "BufferLineIndicatorSelected",
          'NvimTreeNormal',
        },
        exclude_groups = {}, -- table: groups you don't want to clear
      })
    end,
  },

}
