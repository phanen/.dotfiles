return {
  { 'AndrewRadev/linediff.vim', cmd = 'Linediff' },
  { 'folke/lazy.nvim' },
  { 'lilydjwg/fcitx.vim', event = 'InsertEnter' },
  { 'tpope/vim-eunuch', cmd = { 'Rename', 'Delete' } },
  { 'voldikss/vim-translator', cmd = 'Translate' },
  {
    'phanen/broker.nvim',
    event = 'ColorScheme',
    init = function() require('broker.entry').init() end,
  },
  {
    'sportshead/gx.nvim',
    branch = 'git-handler',
    cmd = 'Browse',
    keys = { { 'gl', '<cmd>Browse<cr>', mode = { 'n', 'x' } } },
    opts = {},
  },
}
