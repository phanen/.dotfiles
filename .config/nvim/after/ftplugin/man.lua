-- TODO: BufRead trigger man plugin (set buf)
vim.bo.bh = 'hide'
vim.bo.bt = ''

local n = map.n
local nx = map.nx

-- TODO: not sure why this is needed (ft.lua)
nx('u', '<c-u>', { buffer = 0 })
nx('d', '<c-d>', { buffer = 0, nowait = true })

n('go', require 'man'.show_toc)

-- FIXME: `o` just delete qf/loc/list...
