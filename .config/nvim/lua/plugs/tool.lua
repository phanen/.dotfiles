return {
  -- bug: Nredir =vim.treesitter.get_parser
  -- seems buf should be created after eval...
  { 'sbulav/nredir.nvim', cmd = 'Nredir' },
  { 'suliveevil/vim-redir-output', cmd = 'RedirV' },

  -- HelpfulVersion matchaddpos()
  { 'tweekmonster/helpful.vim', cmd = 'HelpfulVersion' },
  -------------------------------------------------------------------
  { 'mikesmithgh/kitty-scrollback.nvim', cond = false },

  -- archiving
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
  {
    'sontungexpt/url-open',
    cond = false,
    branch = 'mini',
    event = 'VeryLazy',
    cmd = 'URLOpenUnderCursor',
    config = function()
      local status_ok, url_open = pcall(require, 'url-open')
      if not status_ok then return end
      url_open.setup {}
    end,
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
