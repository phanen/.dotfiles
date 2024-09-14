local Ts = {}

local select = require 'nvim-treesitter-textobjects.select'
local move = require 'nvim-treesitter-textobjects.move'
local swap = require 'nvim-treesitter-textobjects.swap'

Ts.select_textobject = select.select_textobject
Ts.goto_next_start = move.goto_next_start
Ts.goto_next_end = move.goto_next_end
Ts.goto_prev_start = move.goto_previous_start
Ts.goto_prev_end = move.goto_previous_end
Ts.goto_next = move.goto_next
Ts.goto_prev = move.goto_previous

Ts.swap_next = swap.swap_next
Ts.swap_prev = swap.swap_previous

return Ts
