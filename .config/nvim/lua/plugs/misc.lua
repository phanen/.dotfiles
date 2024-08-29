return {
  -- dependencies
  { 'folke/lazy.nvim' },
  { 'kyazdani42/nvim-web-devicons' },
  { 'echasnovski/mini.nvim', cond = true, version = false },
  {
    'nvim-lua/plenary.nvim',
    cmd = 'PlenaryBustedDirectory',
    keys = {
      { '+ps', function() require('plenary.profile').start('profile.log', { flame = true }) end },
      { '+pe', function() require('plenary.profile').stop() end },
    },
  },

  -- spell
  {
    'psliwka/vim-dirtytalk',
    build = ':DirtytalkUpdate',
    init = function() vim.opt.spelllang = { 'en', 'programming' } end,
  },

  { 'tweekmonster/helpful.vim', cmd = 'HelpfulVersion' },

  -- fennel
  { 'rktjmp/hotpot.nvim' },

  {
    'folke/which-key.nvim',
    cond = true,
    event = 'VeryLazy',
    keys = {
      {
        '<leader>?',
        function() require('which-key').show({ global = false }) end,
        desc = 'Buffer Local Keymaps (which-key)',
      },
    },
    -- note:
    -- 1. <c-s> feedkey need register...
    -- 2. "_d/c still pend (since we have `ds` `c*`), workaround: maybe "undo" some map??
    opts = {
      preset = 'helix',
      delay = 200,
      plugins = { spelling = { enabled = false } },
      win = { -- `scrolloff` matter here
        border = vim.g.border,
        title = false,
      },
      keys = { scroll_down = '<a-d>', scroll_up = '<a-u>' },
      icons = { rules = false },
      show_help = false,
      show_keys = false, -- also need `win.title = false`
    },
  },
  {
    'folke/zen-mode.nvim',
    cmd = 'ZenMode',
    keys = { { '+z', '<cmd>ZenMode<cr>' } },
    opts = {

      window = {
        backdrop = 1,
        width = 85, -- width of the Zen window
        height = 1, -- height of the Zen window
      },
      plugins = {
        kitty = { enabled = true, font = '+1' },
      },
    },
  },
}
