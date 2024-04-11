return {
  { 'AndrewRadev/linediff.vim', cmd = 'Linediff' },
  { 'famiu/bufdelete.nvim', cmd = 'Bdelete' },
  { 'folke/lazy.nvim' },
  { 'HiPhish/rainbow-delimiters.nvim', event = { 'BufReadPre', 'BufNewFile' } },
  { 'lilydjwg/fcitx.vim', event = 'InsertEnter' },
  { 'mikesmithgh/kitty-scrollback.nvim' },
  { 'tpope/vim-eunuch', cmd = { 'Move', 'Rename', 'Remove', 'Delete', 'Mkdir' } },
  { 'voldikss/vim-translator', cmd = 'Translate' },
  { -- FIXME: register _d, cannot set timeoutlen = 0
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      plugins = { spelling = { enabled = false } },
      popup_mappings = {
        scroll_down = '<a-d>',
        scroll_up = '<a-u>',
      },
    },
  },
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
