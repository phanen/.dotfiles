local g, fn, opt, loop, env, cmd = vim.g, vim.fn, vim.opt, vim.loop, vim.env, vim.cmd

vim.g.os = vim.loop.os_uname().sysname
vim.g.open_cmd = vim.g.os == 'Linux' and 'xdg-open' or 'open'

vim.g.mapleader = ' '
vim.g.maplocalleader = ','

require('keymaps')
require('settings')
require('lazyman')

-- built-in packages
-- filter down a quickfix list
cmd.packadd('cfilter')
vim.cmd [[colorscheme tokyonight]]
