return {
  'psliwka/vim-dirtytalk',
  build = ':DirtytalkUpdate',
  init = function() vim.opt.spelllang = { 'en', 'programming' } end,
}
