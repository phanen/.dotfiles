local g, fn, opt, loop, env, cmd = vim.g, vim.fn, vim.opt, vim.loop, vim.env, vim.cmd

g.os = loop.os_uname().sysname
g.open_cmd = g.os == 'Linux' and 'xdg-open' or 'open'

g.mapleader = ' '
g.maplocalleader = ','

require('keymaps')
require('settings')
require('lazyman')

-- filter down a quickfix list
cmd.packadd('cfilter')

g.colorscheme = env.TERM == 'linux' and 'default' or 'kanagawa-lotus'
vim.cmd('colorscheme ' .. g.colorscheme )
