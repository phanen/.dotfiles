return {
  {
    'chrisgrieser/nvim-various-textobjs',
    opts = {
      lookForwardSmall = 10,
      lookForwardBig = 30,
      useDefaultKeymaps = false,
      notifyNotFound = false,
    },
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    opts = {
      select = {
        lookahead = true,
        set_jumps = true,
        selection_modes = {
          ['@parameter.outer'] = 'v', -- charwise
          ['@function.outer'] = 'V', -- linewise
          ['@class.outer'] = '<c-v>', -- blockwise
        },
      },
      move = { set_jumps = true },
    },
  },
}
