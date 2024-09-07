local Repmove = {}
-- TODO: similar, textobjects + repeat expand by <cr>
-- TODO: https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-bracketed.md

-- treesitter textobjects register their motions on this impl (so this is necessary now)
local ts_repmove = require('nvim-treesitter.textobjects.repeatable_move')

local next_hunk = function() -- gitsigns handle v:count by itself
  if vim.wo.diff then return vim.cmd.normal { '[c', bang = true } end
  require('gitsigns').nav_hunk('next', { target = 'all' })
end
local prev_hunk = function()
  if vim.wo.diff then return vim.cmd.normal { ']c', bang = true } end
  require('gitsigns').nav_hunk('prev', { target = 'all' })
end

local next_diag = function()
  -- TODO: need refresh or lsp too slow??
  -- vim.cmd.up()
  return vim.diagnostic.jump { count = vim.v.count1 }
end
local prev_diag = function()
  -- vim.cmd.up()
  return vim.diagnostic.jump { count = -vim.v.count1 }
end

-- TODO: make it wrapable
local next_qfit = function() return vim.cmd('sil! ' .. vim.v.count1 .. 'cnext') end
local prev_qfit = function() return vim.cmd('sil! ' .. vim.v.count1 .. 'cprev') end

local next_llit = function() return vim.cmd('sil! ' .. vim.v.count1 .. 'lnext') end
local prev_llit = function() return vim.cmd('sil! ' .. vim.v.count1 .. 'lprev') end

Repmove.next_hunk, Repmove.prev_hunk = ts_repmove.make_repeatable_move_pair(next_hunk, prev_hunk)
Repmove.next_diag, Repmove.prev_diag = ts_repmove.make_repeatable_move_pair(next_diag, prev_diag)
Repmove.next_qfit, Repmove.prev_qfit = ts_repmove.make_repeatable_move_pair(next_qfit, prev_qfit)
Repmove.next_llit, Repmove.prev_llit = ts_repmove.make_repeatable_move_pair(next_llit, prev_llit)

return setmetatable(Repmove, { __index = ts_repmove })
