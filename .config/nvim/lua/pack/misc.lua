return {
  { 'AndrewRadev/linediff.vim', cmd = 'Linediff' },
  { 'folke/lazy.nvim' },
  { 'lilydjwg/fcitx.vim', event = 'InsertEnter' },
  { 'tpope/vim-eunuch', cmd = { 'Rename', 'Delete' } },
  { 'voldikss/vim-translator', cmd = 'Translate' },
  {
    'chrishrb/gx.nvim',
    cmd = 'Browse',
    keys = { { 'gl', '<cmd>Browse<cr>', mode = { 'n', 'x' } } },
    opts = {},
  },
}
