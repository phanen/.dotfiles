return {
  'kylechui/nvim-surround',
  keys = {
    'cs',
    'ds',
    'ys',
    { 's', mode = 'x' },
    { '`', '<Plug>(nvim-surround-visual)`', mode = 'x' },
    { 'q', '<Plug>(nvim-surround-visual)"', mode = 'x' },
  },
  opts = {
    keymaps = { insert = false, visual = 's' },
    surrounds = {
      ['j'] = {
        add = { '**', '**' },
        find = '%*%*.-%*%*',
        delete = '^(%*%*?)().-(%*%*?)()$',
      },
      ['M'] = { add = { '$$', '$$' } },
      ['['] = {
        add = { '[[', ']]' },
        find = { '[[', ']]' },
        delete = { '[[', ']]' },
      },

      -- 'r' is the same as it...
      -- [']'] = {
      --   add = { '[[ ', ' ]]' },
      --   find = { '[[ ', ' ]]' },
      --   delete = { '[[ ', ' ]]' },
      -- },
      -- ['r'] = {
      --   add = { '[', ']' },
      --   find = { '[', ']' },
      --   delete = { '[', ']' },
      -- },
    },
    aliases = {
      ['n'] = '}',
      ['q'] = '"',
      ['m'] = '$',
    },
  },
}
