local g, fn, opt, loop, env, cmd = vim.g, vim.fn, vim.opt, vim.loop, vim.env, vim.cmd

vim.g.os = vim.loop.os_uname().sysname
vim.g.open_cmd = vim.g.os == 'Linux' and 'xdg-open' or 'open'

vim.g.mapleader = ' '
vim.g.maplocalleader = ','

require('keymaps')
require('settings')
require('pm')

vim.keymap.set('n', '<leader>pm', '<cmd>Lazy<cr>', { desc = 'manage' })

-- set colorscheme
vim.cmd [[colorscheme tokyonight]]
-- catppuccin

-- advanced term
require('toggleterm').setup({
    open_mapping = [[<c-\>]],
    start_in_insert = true,
    direction = 'float'
})

local Term = require('toggleterm.terminal').Terminal
local pyterm = Term:new({
    cmd = 'python',
    directon = 'horizontal',
})

vim.keymap.set('t', '<esc>', '<c-\\><c-n>', opts)
vim.keymap.set('n', '<leader>tt',  '<c-\\>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>tp', function() pyterm:toggle() end, opts)
vim.keymap.set('n', '<f2>', '<cmd>NvimTreeToggle<cr>', opts)
vim.keymap.set('n', '<f3>', '<cmd>AerialToggle<cr>', opts)
vim.keymap.set('n', '<f4>', '<cmd>MarkdownPreview<cr>', opts)

-- built-in packages
-- filter down a quickfix list
cmd.packadd('cfilter')
