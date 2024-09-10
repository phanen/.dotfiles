local Buf = {}

-- TODO: get rid of dep
---@param bufname string?
---@param root string
---@return string
function Buf.relative_to(bufname, root)
  bufname = bufname or api.nvim_buf_get_name(0)
  return require('fzf-lua').path.relative_to(bufname, root)
end

-- for vim without fn.getregion
local getregion = function(mode)
  local sl, sc = fn.line 'v', fn.col 'v'
  local el, ec = fn.line '.', fn.col '.'
  if sl > el then
    sl, sc, el, ec = el, ec, sl, sc
  elseif sl == el and sc > ec then
    sc, ec = ec, sc
  end
  local lines = api.nvim_buf_get_lines(0, sl - 1, el, false)
  if mode == 'v' then
    if #lines == 1 then
      lines[1] = lines[1]:sub(sc, ec)
    else
      lines[1] = lines[1]:sub(sc)
      lines[#lines] = lines[#lines]:sub(1, ec)
    end
  elseif mode == '\022' then -- not sure behavior
    for i, line in pairs(lines) do
      if #line >= ec then
        lines[i] = line:sub(sc, ec)
      elseif #line < sc - 1 then
        lines[i] = (' '):rep(ec - sc + 1)
      elseif #line < sc then
        lines[i] = ''
      else
        lines[i] = line:sub(sc, nil)
      end
    end
  end
  return lines
end

-- get visual selected with no side effect
Buf.getregion = function(mode)
  mode = mode or api.nvim_get_mode().mode
  if not mode:match('[vV\022]') then return {} end
  local ok, lines = pcall(fn.getregion, fn.getpos '.', fn.getpos 'v', { type = mode })
  if ok then return lines end
  return getregion(mode)
end

---[(0,1)-index, exclude)
---@return integer, integer
Buf.visual_region = function()
  local vs, ve = vim.fn.line '.', vim.fn.line 'v'
  if vs > ve then
    vs, ve = ve, vs
  end
  return vs - 1, ve
end

return Buf
