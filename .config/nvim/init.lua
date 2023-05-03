local g, fn, opt, loop, env, cmd = vim.g, vim.fn, vim.opt, vim.loop, vim.env, vim.cmd

-- g.os = loop.os_uname().sysname
-- g.open_cmd = g.os == 'Linux' and 'xdg-open' or 'open'

g.mapleader = ' '
g.maplocalleader = ','

require('keymaps')
require('settings')
require('lazyman')

-- filter down a quickfix list
cmd.packadd('cfilter')


local cur_hour = tonumber(fn.system('date +%H'))
if env.TERM == 'linux' then
  g.colorscheme = 'default'
elseif cur_hour >= 18 or cur_hour <= 6 then
  g.colorscheme = 'kanagawa-wave'
else
  g.colorscheme = 'kanagawa-lotus'
end
vim.cmd('colorscheme ' .. 'kanagawa-wave' )
