local path = vim.fs.joinpath(vim.g.lazy_path, 'lazy.nvim')
if not vim.uv.fs_stat(path) then
  vim.fn.system { 'git', 'clone', '--branch=stable', 'https://github.com/folke/lazy.nvim', path }
end

vim.opt.rtp:prepend(path)
require('lazy').setup {
  spec = {
    { import = 'plugins.cmp' },
    { import = 'plugins.edit' },
    { import = 'plugins.fzf' },
    { import = 'plugins.git' },
    { import = 'plugins.lsp' },
    { import = 'plugins.misc' },
    { import = 'plugins.ts' },
    { import = 'plugins.stage' },
  },
  lockfile = vim.fn.stdpath('data') .. '/lazy-lock.json',
  defaults = { lazy = true },
  change_detection = { enabled = false, notify = false },
  git = { filter = false }, -- blame it
  dev = { path = '~/b', patterns = { 'phanen' }, fallback = true },
  performance = {
    rtp = {
      reset = false,
      disabled_plugins = {
        'matchit',
        'matchparen',
        'netrwPlugin',
        'nvim',
        'osc52',
        'rplugin',
        'shada',
        'spellfile',
        'tohtml',
        'tutor',
      },
    },
  },
}

-- preserve one more rtp for docs only
vim.opt.rtp:append(vim.g.docs_path)
