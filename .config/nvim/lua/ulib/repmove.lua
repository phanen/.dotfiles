local Repmove = {}
-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-bracketed.md
--
-- treesitter textobjects register their motions on this impl (so this is necessary now)
local ts_repmove = require('nvim-treesitter.textobjects.repeatable_move')

local next_hunk = function() -- gitsigns handle v:count by itself
  if vim.wo.diff then return vim.cmd.normal { ']c', bang = true } end
  require('gitsigns').nav_hunk('next', { target = 'all' })
end
local prev_hunk = function()
  if vim.wo.diff then return vim.cmd.normal { '[c', bang = true } end
  require('gitsigns').nav_hunk('prev', { target = 'all' })
end

local next_diag = function() return vim.diagnostic.jump { count = vim.v.count1, float = false } end
local prev_diag = function() return vim.diagnostic.jump { count = -vim.v.count1, float = false } end

-- if we don't care able wrap
local gen = function(cmd_next, cmd_prev)
  local n = function()
    return vim.cmd[cmd_next] { count = vim.v.count1, mods = { emsg_silent = true } }
  end
  local p = function()
    return vim.cmd[cmd_prev] { count = vim.v.count1, mods = { emsg_silent = true } }
  end
  return n, p
end

local next_spel = function() vim.cmd.normal { vim.v.count1 .. ']s', bang = true } end
local prev_spel = function() vim.cmd.normal { vim.v.count1 .. '[s', bang = true } end

Repmove.next_h, Repmove.prev_h = ts_repmove.make_repeatable_move_pair(next_hunk, prev_hunk)
Repmove.next_d, Repmove.prev_d = ts_repmove.make_repeatable_move_pair(next_diag, prev_diag)
Repmove.next_q, Repmove.prev_q = ts_repmove.make_repeatable_move_pair(gen('cnext', 'cprev'))
Repmove.next_l, Repmove.prev_l = ts_repmove.make_repeatable_move_pair(gen('lnext', 'lprev'))
Repmove.next_b, Repmove.prev_b = ts_repmove.make_repeatable_move_pair(gen('bnext', 'bprev'))
Repmove.next_s, Repmove.prev_s = ts_repmove.make_repeatable_move_pair(next_spel, prev_spel)

Repmove.next_o, Repmove.prev_o =
  ts_repmove.make_repeatable_move_pair(u.bufop.backward_buf, u.bufop.forward_buf)

Repmove.next_d, Repmove.prev_d = ts_repmove.make_repeatable_move_pair(next_diag, prev_diag)

Repmove.make_pair = ts_repmove.make_repeatable_move_pair

return setmetatable(Repmove, { __index = ts_repmove })
