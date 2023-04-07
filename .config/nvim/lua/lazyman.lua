local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  }
end

vim.opt.rtp:prepend(lazypath)

-- if open from inside neovim terminal, then do not load other plugins
if vim.env.NVIM then return require('lazy').setup({ { 'willothy/flatten.nvim', config = true } }) end

vim.o.completeopt = 'menuone,noselect,noinsert'
require('lazy').setup('plugins',
  {
    defaults = { lazy = true },
    change_detection = { notify = false },
    checker = {
      enabled = false,
      concurrency = 30,
      notify = false,
      frequency = 3600,
    },
    install = {
      missing = true,
      colorscheme = { 'nightfox', 'tokyonight', 'habamax' },
    },
    performance = {
      rtp = {
        paths = { vim.fn.stdpath('data') .. '/site' },
        disabled_plugins = { 'netrw', 'netrwPlugin' },
      },
    },
  }
)
