local Buf = {}

---@param bufname string?
---@param root string
---@return string
function Buf.relative_to(bufname, root)
  bufname = bufname or api.nvim_buf_get_name(0)
  return require('fzf-lua').path.relative_to(bufname, root)
end

Buf.sort_range = function(ls, cs, le, ce)
  if ls > le then
    ls, cs, le, ce = le, ce, ls, cs
  elseif ls == le and cs > ce then
    cs, ce = ce, cs
  end
  return ls, cs, le, ce
end

-- for vim without fn.getregion
Buf.getregion2 = function(mode)
  local ls, cs = fn.line 'v', fn.col 'v'
  local le, ce = fn.line '.', fn.col '.'
  if ls > le then
    ls, cs, le, ce = le, ce, ls, cs
  elseif ls == le and cs > ce then
    cs, ce = ce, cs
  end
  local lines = api.nvim_buf_get_lines(0, ls - 1, le, false)
  if mode == 'v' then
    if #lines == 1 then
      lines[1] = lines[1]:sub(cs, ce)
    else
      lines[1] = lines[1]:sub(cs)
      lines[#lines] = lines[#lines]:sub(1, ce)
    end
  elseif mode == '\022' then -- not sure behavior
    for i, line in pairs(lines) do
      if #line >= ce then
        lines[i] = line:sub(cs, ce)
      elseif #line < cs - 1 then
        lines[i] = (' '):rep(ce - cs + 1)
      elseif #line < cs then
        lines[i] = ''
      else
        lines[i] = line:sub(cs, nil)
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
  local ls, cs = pos1[2], pos1[3]
  local le, ce = pos2[2], pos2[3]
  ls, cs, le, ce = Buf.sort_range(ls, cs, le, ce)
  if mode == 'v' then
    if ce == fn.col '$' then
      if le ~= fn.line '$' then
        le, ce = le + 1, 0
      else
        ce = ce - 1
      end
    end
    api.nvim_buf_set_text(buf, ls - 1, cs - 1, le - 1, ce, replace)
  else
    api.nvim_buf_set_lines(buf, ls - 1, le, true, replace)
    api.nvim_win_set_cursor(fn.bufwinid(buf), { ls, cs - 1 })
  end
  api.nvim_feedkeys(vim.keycode '<esc>', 'n', false)
end

Buf.delete_range = function(pos1, pos2, buf, mode) Buf.replace_range({}, pos1, pos2, buf, mode) end

---Get the range of the current visual selection.
---starts with 1 and the ending is inclusive.
---@return integer, integer, integer, integer
Buf.visual_range = function()
  local _, ls, cs, _ = unpack(fn.getpos 'v')
  local _, le, ce, _ = unpack(fn.getpos '.')
  return Buf.sort_range(ls, cs, le, ce)
end

return Buf
