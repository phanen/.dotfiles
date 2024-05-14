return {
  { 'AndrewRadev/linediff.vim', cmd = 'Linediff' },
  { 'folke/lazy.nvim' },
  -- buggy in wayalnd
  { 'lilydjwg/fcitx.vim', cond = not vim.env.WAYLAND_DISPLAY, event = 'InsertEnter' },
  { 'tpope/vim-eunuch', cmd = { 'Rename', 'Delete' } },
  { 'voldikss/vim-translator', cmd = 'Translate' },
  {
    'chrishrb/gx.nvim',
    cmd = 'Browse',
    keys = { { 'gl', '<cmd>Browse<cr>', mode = { 'n', 'x' } } },
    opts = {},
  },
}
