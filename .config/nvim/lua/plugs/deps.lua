-- otherwise, we'll get semantic error (upstream?)
g.linediff_buffer_type = 'scratch'

return {
  { 'folke/lazy.nvim' },
  { 'kyazdani42/nvim-web-devicons' },
  { 'echasnovski/mini.nvim', version = false },
  { 'nvim-lua/plenary.nvim', cmd = 'PlenaryBustedDirectory' },
  { 'kevinhwang91/promise-async' },
  { 'tweekmonster/helpful.vim', cmd = 'HelpfulVersion' },
  { 'junegunn/fzf.vim', cmd = { 'Files', 'RG', 'Rg' } },

  {
    'williamboman/mason.nvim',
    cmd = 'Mason',
    opts = {
      ui = { height = 0.85, width = 0.95, border = g.border },
      registries = {
        'github:phanen/mason-registry-extra',
        'github:mason-org/mason-registry',
      },
    },
  },
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    cmd = { 'TSUpdate', 'TSInstall', 'TSUninstall' },
    build = ':TSUpdate', -- ./scripts/update-parsers.lua
    opts = { ensure_install = { 'all' } },
  },
  { 'neovim/nvim-lspconfig' },
  { 'b0o/SchemaStore.nvim' },

  { 'AndrewRadev/linediff.vim', cmd = 'Linediff', keys = '<Plug>(linediff-operator)' },
  { 'junegunn/vim-easy-align', cmd = 'EasyAlign' },
  { 'onsails/lspkind.nvim', opts = {} },
  { 'tpope/vim-eunuch', cmd = { 'Rename', 'Delete' } },
  { 'tpope/vim-sleuth', lazy = false },
  { 'andrewferrier/debugprint.nvim', opts = {} },
}
