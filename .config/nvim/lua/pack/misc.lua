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
    opts = { plugins = { spelling = { enabled = false } } },
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
  {
    'akinsho/toggleterm.nvim',
    keys = { '<c-\\>' },
    opts = { open_mapping = '<c-\\>', direction = 'float', shell = '/bin/fish' },
    config = function(_, opts)
      require('toggleterm').setup(opts)
      local Terminal = require('toggleterm.terminal').Terminal
      local lazygit = Terminal:new({ cmd = 'lazygit', hidden = true })
      function _lazygit_toggle() lazygit:toggle() end
      vim.api.nvim_set_keymap(
        'n',
        '<leader>gg',
        '<cmd>lua _lazygit_toggle()<CR>',
        { noremap = true, silent = true }
      )
    end,
  },
}
