local Buf = {}

Buf.sort_range = function(start_row, start_col, end_row, end_col)
  if start_row > end_row then
    start_row, start_col, end_row, end_col = end_row, end_col, start_row, start_col
  elseif start_row == end_row and start_col > end_col then
    start_col, end_col = end_col, start_col
  end
  return start_row, start_col, end_row, end_col
end

-- for vim without fn.getregion
Buf.getregion2 = function(mode)
  local start_row, start_col = fn.line 'v', fn.col 'v'
  local end_row, end_col = fn.line '.', fn.col '.'
  if start_row > end_row then
    start_row, start_col, end_row, end_col = end_row, end_col, start_row, start_col
  elseif start_row == end_row and start_col > end_col then
    start_col, end_col = end_col, start_col
  end
  local lines = api.nvim_buf_get_lines(0, start_row - 1, end_row, false)
  if mode == 'v' then
    if #lines == 1 then
      lines[1] = lines[1]:sub(start_col, end_col)
    else
      lines[1] = lines[1]:sub(start_col)
      lines[#lines] = lines[#lines]:sub(1, end_col)
    end
  elseif mode == '\022' then -- not sure behavior
    for i, line in pairs(lines) do
      if #line >= end_col then
        lines[i] = line:sub(start_col, end_col)
      elseif #line < start_col - 1 then
        lines[i] = (' '):rep(end_col - start_col + 1)
      elseif #line < start_col then
        lines[i] = ''
      else
        lines[i] = line:sub(start_col, nil)
      end
    end
  end
  return lines
end

-- get visual selected with no side effect
Buf.getregion = function(mode)
  mode = mode or api.nvim_get_mode().mode
  if not mode:match('[vV\022]') then return {} end
  return fn.getregion(fn.getpos '.', fn.getpos 'v', { type = mode })
end

---1-index
---@return integer, integer
Buf.visual_line_region = function()
  local sv, ev = fn.line '.', fn.line 'v'
  if sv > ev then
    sv, ev = ev, sv
  end
  return sv, ev
end

Buf.replace_range = function(replace, pos1, pos2, buf, mode)
  buf = buf or api.nvim_get_current_buf()
  mode = mode or api.nvim_get_mode().mode
  assert(mode:match('[vV]'), ('mode: %s'):format(mode))
  if not pos1 and not pos2 then
    pos1, pos2 = fn.getpos '.', fn.getpos 'v'
  end
  local start_row, start_col = pos1[2], pos1[3]
  local end_row, end_col = pos2[2], pos2[3]
  start_row, start_col, end_row, end_col = Buf.sort_range(start_row, start_col, end_row, end_col)
  if mode == 'v' then
    if end_col == fn.col '$' then
      if end_row ~= fn.line '$' then
        end_row, end_col = end_row + 1, 0
      else
        end_col = end_col - 1
      end
    end
    api.nvim_buf_set_text(buf, start_row - 1, start_col - 1, end_row - 1, end_col, replace)
  else
    api.nvim_buf_set_lines(buf, start_row - 1, end_row, true, replace)
    api.nvim_win_set_cursor(fn.bufwinid(buf), { start_row, start_col - 1 })
  end
  api.nvim_feedkeys(vim.keycode '<esc>', 'n', false)
end

Buf.delete_range = function(pos1, pos2, buf, mode) Buf.replace_range({}, pos1, pos2, buf, mode) end

---Get the range of the current visual selection.
---starts with 1 and the ending is inclusive.
---@return integer, integer, integer, integer
Buf.visual_range = function()
  local _, start_row, start_col, _ = unpack(fn.getpos 'v')
  local _, end_row, end_col, _ = unpack(fn.getpos '.')
  return Buf.sort_range(start_row, start_col, end_row, end_col)
end

return Buf
