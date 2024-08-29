-- TODO: dsi dsa not work?
-- motion

require 'map.buf'
require 'map.comment'
require 'map.common'
require 'map.diag'
require 'map.fmt'
require 'map.msg'
require 'map.tab'
require 'map.textobj'
require 'map.win'

local n = map.n
local x = map.n
local nx = map.nx

-- FIXME: se co=9999
n(' ol', '<cmd>se co=80<cr>')
n(' or', '<cmd>ret<cr>')
n(' os', '<cmd>se spell!<cr>')
n(' ow', '<cmd>se wrap!<cr>')

-- misc
n('+E', '<cmd>lua vim.treesitter.query.edit()<cr>')
n('+I', '<cmd>lua vim.treesitter.inspect_tree()<cr>')

-- you know the trick
n('+L', u.lazy.lazy_chore_update)
n(' I', '<cmd>lua vim.show_pos()<cr>')
-- TODO: kill buffer when close
nx(' E', ':EditCodeBlock<cr>')
nx(' L', ':Linediff<cr>')

n(" '", '<cmd>marks<cr>')
n(' "', '<cmd>reg<cr>')

n('-', '<cmd>TSJToggle<cr>')
nx('_', 'K')
nx('K', ':Translate<cr>')

n(' cd', u.smart.cd)
n(' cf', '<cmd>cd %:h<cr>')
n(' cy', u.util.yank_filename)

-- https://github.com/search?q=cgn+lang:vim
n(' c*', [[<cmd>let @/='\<'.expand('<cword>').'\>'<cr>"_cgn]])
x(' c*', [[sy:let @/=@s<cr>cgn]])

n(' cx', '<cmd>!chmod +x %<cr>')
n(' cX', '<cmd>!chmod -x %<cr>')

n('+rd', ':Delete!')
n('+rr', function() return ':Rename ' .. api.nvim_buf_get_name(0) end, { expr = true })

n('i', function()
  if vim.v.count > 0 then return 'i' end
  if #api.nvim_get_current_line() == 0 then
    return [["_cc]]
  else
    return 'i'
  end
end, { expr = true })

-- session
-- TODO: more thing need to be preserved, `SessionWritePost`
n(' ss', '<cmd>mksession! /tmp/Session.vim<cr><cmd>q!<cr>')
n(' sl', '<cmd>so /tmp/Session.vim<cr>')
nx(' so', ':so<cr>')

n(' t', ':e /tmp/tmp/')

-- fastmove
nx('h', u.faster.h, { expr = true })
nx('l', u.faster.l, { expr = true })
nx('j', u.faster.j, { expr = true })
nx('k', u.faster.k, { expr = true })
nx('<c-d>', u.faster['<c-d>'], { expr = true })
nx('<c-u>', u.faster['<c-u>'], { expr = true })
