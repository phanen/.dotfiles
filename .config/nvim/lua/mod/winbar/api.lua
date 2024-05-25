local M = {}
local u = require('mod.winbar.utils')

---@return winbar_t?
M.get_current_winbar = function() return u.bar.get { win = api.nvim_get_current_win() } end

---Goto the start of context
---If `count` is 0, goto the start of current context, or the start at
---prev context if cursor is already at the start of current context;
---If `count` is positive, goto the start of `count` prev context
---@param count integer? default vim.v.count
M.goto_context_start = function(count)
  count = count or vim.v.count
  local bar = M.get_current_winbar()
  if not bar or not bar.components or vim.tbl_isempty(bar.components) then return end
  local current_sym = bar.components[#bar.components]
  if not current_sym.range then return end
  local cursor = api.nvim_win_get_cursor(0)
  if
    count == 0
    and current_sym.range.start.line == cursor[1] - 1
    and current_sym.range.start.character == cursor[2]
  then
    count = count + 1
  end
  while count > 0 do
    count = count - 1
    local prev_sym = bar.components[current_sym.bar_idx - 1]
    if not prev_sym or not prev_sym.range then break end
    current_sym = prev_sym
  end
  current_sym:jump()
end

---Open the menu of current context to select the next context
M.select_next_context = function()
  local bar = M.get_current_winbar()
  if not bar or not bar.components or vim.tbl_isempty(bar.components) then return end
  bar:pick_mode_wrap(function() bar.components[#bar.components]:on_click() end)
end

---Pick a component from current winbar
---@param idx integer?
M.pick = function(idx)
  local bar = M.get_current_winbar()
  if bar then bar:pick(idx) end
end

return M
