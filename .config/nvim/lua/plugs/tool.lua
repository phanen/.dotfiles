return {
  -- HelpfulVersion matchaddpos()
  { 'tweekmonster/helpful.vim', cmd = 'HelpfulVersion' },

  { 'mikesmithgh/kitty-scrollback.nvim', cond = false },

  { 'voldikss/vim-hello-word', cond = false },
  {
    'neovim/nvimdev.nvim',
    cond = false,
    cmd = { 'NvimTestRun', 'NvimTestClear' },
    config = true,
  },
  { 'tamton-aquib/mpv.nvim', cmd = 'MpvToggle', opts = {} },
  {
    'potamides/pantran.nvim',
    cond = false,
    cmd = 'Pantran',
    opts = {},
  },

  -- lineno + colno
  { 'wsdjeg/vim-fetch', cond = false, event = { 'BufReadPre', 'BufNewFile' } },

  {
    'carlosrocha/chrome-remote.nvim',
    cond = false,
    -- lazy = false,
    opts = {
      connection = {
        host = 'localhost',
        port = 9222,
      },
    },
  },
}
