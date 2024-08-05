return {
  { import = 'plugs' },
  { import = 'mods' },
  -- -- FIXME: should trigger only once (other than once for each event)
  -- au({
  --   'CmdlineEnter',
  --   'InsertEnter',
  -- }, {
  --   once = true,
  --   group = ag('InsertMappings', { clear = true }),
  --   callback = function()
  --     -- vim.print('loaded insertmappings')
  --     -- FIXME: order matter, do not override cmp
  --     u.insert.setup()
  --   end,
  -- })
  -- {
  --   dir = 'mod',
  --   main = 'mod.insert',
  --   event = { 'CmdlineEnter', 'InsertEnter' },
  --   opts = {},
  -- },
  { 'nvim-neorocks/lz.n', mod = true },
  { 'stevearc/dressing.nvim', lazy = false },
  -- TODO:
  -- https://github.com/liangxianzhe/floating-input.nvim
  {
    'psliwka/vim-dirtytalk',
    build = ':DirtytalkUpdate',
    config = function() vim.opt.spelllang = { 'en', 'programming' } end,
  },
  { 'rktjmp/hotpot.nvim', lazy = true },
  { 'AndrewRadev/linediff.vim', cmd = 'Linediff' },
  { 'folke/lazy.nvim' },
  -- buggy in wayalnd
  -- { 'lilydjwg/fcitx.vim', cond = not env.WAYLAND_DISPLAY, event = 'InsertEnter' },
  { 'tpope/vim-eunuch', cmd = { 'Rename', 'Delete' } },
  { 'voldikss/vim-translator', cmd = 'Translate' },
  -- { 'Konfekt/vim-select-replace', lazy = false },
  -- todo
  { 'echasnovski/mini.nvim', cond = true, version = false },
  { 'monaqa/modesearch.vim', cond = true, keys = { { 'g/', '<Plug>(modesearch-slash)' } } },
  { 'chentoast/marks.nvim', cond = false, lazy = false, opts = {} },
  -- not work?
  {
    'kevinhwang91/nvim-fundo',
    cond = false,
    event = { 'BufReadPre' },
    dependencies = 'kevinhwang91/promise-async',
    build = function() require('fundo').install() end,
    opts = {},
  },
  {
    'ThePrimeagen/refactoring.nvim',
    keys = {
      { '<leader>re', ':Refactor extract ', mode = 'x' },
      { '<leader>rf', ':Refactor extract_to_file ', mode = 'x' },
      { '<leader>rv', ':Refactor extract_var ', mode = 'x' },
      { '<leader>ri', ':Refactor inline_var', mode = { 'n', 'x' } },
      { '<leader>rI', ':Refactor inline_func', mode = 'n' },
      { '<leader>rb', ':Refactor extract_block', mode = 'n' },
      { '<leader>rbf', ':Refactor extract_block_to_file', mode = 'n' },
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function() require('refactoring').setup() end,
  },
}
