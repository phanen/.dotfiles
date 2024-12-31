local Ts = {}

local select = u.lreq 'nvim-treesitter-textobjects.select'
local move = u.lreq 'nvim-treesitter-textobjects.move'
local swap = u.lreq 'nvim-treesitter-textobjects.swap'

local use_syntax = {
  po = true,
}

---@autocmd
Ts.setup = function(_)
  local buf = _.buf
  local ft = vim.bo[buf].ft
  if vim.b.disable_ts or use_syntax[ft] then
    vim.bo[buf].syntax = ft or use_syntax[ft] or ''
    return
  end
  local ok = pcall(ts.start)
  if not ok then return end
  vim.wo.foldmethod = 'expr'
  vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  vim.wo.foldtext = ''
end

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
