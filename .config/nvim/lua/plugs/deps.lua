return {
  { 'folke/lazy.nvim' },
  { 'kyazdani42/nvim-web-devicons' },
  { 'echasnovski/mini.nvim', version = false },
  { 'nvim-lua/plenary.nvim', cmd = 'PlenaryBustedDirectory' },
  { 'kevinhwang91/promise-async' },
  { 'tweekmonster/helpful.vim', cmd = 'HelpfulVersion' },
  { 'junegunn/fzf.vim', cmd = { 'Files', 'RG', 'Rg' } },

  { 'folke/flash.nvim' },

  {
    'williamboman/mason.nvim',
    cmd = 'Mason',
    opts = { ui = { height = 0.85, width = 0.95, border = g.border } },
  },
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    cmd = { 'TSUpdate', 'TSInstall', 'TSUninstall' },
    build = ':TSUpdate', -- ./scripts/update-parsers.lua
    opts = { ensure_install = { 'all' } },
  },
  { 'neovim/nvim-lspconfig' },

  { 'AndrewRadev/linediff.vim', cmd = 'Linediff' },
  { 'junegunn/vim-easy-align', cmd = 'EasyAlign' },
  { 'gbprod/substitute.nvim', opts = {} },
  { 'onsails/lspkind.nvim', opts = {} },
  { 'tpope/vim-eunuch', cmd = { 'Rename', 'Delete' } },
  { 'tpope/vim-sleuth', lazy = false },
  { 'andrewferrier/debugprint.nvim', opts = {} },
}
