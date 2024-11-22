-- 'chrisgrieser/nvim-various-textobjs'
local M = {}

local is_blank = function(lnr)
  local pattern = '^%s*$'
  local line = api.nvim_buf_get_lines(0, lnr - 1, lnr, true)[1]
  return line:find(pattern) ~= nil
end

local not_blank = function(lnr) return not is_blank(lnr) end

local is_comment = function(lnr)
  local pattern = '^%s*' .. vim.pesc(vim.bo.commentstring):gsub(' ?%%%%s ?', '.*') .. '%s*$'
  local line = api.nvim_buf_get_lines(0, lnr - 1, lnr, true)[1]
  return line:find(pattern) ~= nil
end

---@param match fun(lnr: integer)
---@param n integer?
---@return integer|nil, integer|nil # todo: stupid
local region_match = function(match, n, with_pre, with_after)
  if not n or n < 0 then n = math.huge end
  local start, last = fn.line('.'), fn.line('$')
  local cur = start
  while not match(cur) do
    if cur == last or cur > start + n then return end
    cur = cur + 1
  end
  local prev, next = cur, cur
  while prev > 0 and match(prev) do
    prev = prev - 1
  end
  while next <= last and match(next) do
    next = next + 1
  end
  local p = with_pre and 0 or 1
  local q = with_after and 0 or 1
  return prev + p, next - q
end

---@param outer boolean?
local region_codeblock = function(outer)
  -- scan buffer for all code blocks, add beginnings & endings to a table each
  local cb_begin = {}
  local cb_end = {}
  local lines = api.nvim_buf_get_lines(0, 0, -1, true)

  local i = 1
  local fench = '^```%w*$'
  for _, line in pairs(lines) do
    if line:find(fench) then
      if #cb_begin == #cb_end then
        table.insert(cb_begin, i)
      else
        table.insert(cb_end, i)
      end
    end
    i = i + 1
  end

  if #cb_begin > #cb_end then table.remove(cb_begin) end

  local cur = fn.line('.')
  -- determine cursor location in a codeblock
  local j = 0
  repeat
    j = j + 1
    if j > #cb_begin then return end
    local cursorInBetween = (cb_begin[j] <= cur) and (cb_end[j] >= cur)
    -- seek forward for a codeblock
    local cursorInFront = (cb_begin[j] > cur) and (cb_begin[j] <= cur + 30)
  until cursorInBetween or cursorInFront

  local start = cb_begin[j]
  local last = cb_end[j]
  if not outer then
    start = start + 1
    last = last - 1
  end
  return start, last
end

---@param with_pre? boolean
---@param with_after? boolean
---@param with_blank? boolean
local region_indent = function(with_pre, with_after, with_blank)
  local cur, last = fn.line('.'), fn.line('$')
  while is_blank(cur) do
    if last == cur then return end
    cur = cur + 1
  end
  local indent = fn.indent(cur)
  local prev, next = cur - 1, cur + 1
  while prev > 0 and ((with_blank and is_blank(prev)) or fn.indent(prev) >= indent) do
    prev = prev - 1
  end
  while next <= last and ((with_blank and is_blank(next)) or fn.indent(next) >= indent) do
    next = next + 1
  end
  if not with_pre then prev = prev + 1 end
  if not with_after then next = next - 1 end
  while is_blank(next) do
    next = next - 1
  end
  return prev, next
end

-- linewise do (delete, visual, yank) by region
-- https://stackoverflow.com/questions/19195160/push-a-location-to-the-jumplist
local linewise = function(s, e)
  if not s or not e then return end
  vim.cmd.normal { 'm`', bang = true }
  fn.cursor(s, 0)
  if not fn.mode():find('V') then vim.cmd.normal { 'V', bang = true } end
  vim.cmd.normal { 'o', bang = true }
  fn.cursor(e, 0)
end

local buffer = function() linewise(1, fn.line('$')) end

local codeblock_fn = function(outer)
  return function() linewise(region_codeblock(outer)) end
end

local comment = function()
  if vim.bo.commentstring == '' then return end
  linewise(region_match(is_comment))
end

-- lower/upper: with blank or not
local indent_fn = function(with_border, with_blank)
  return function()
    -- if at top level, then same as
    if fn.indent('.') == 0 then return linewise(region_match(not_blank)) end
    return linewise(region_indent(with_border, with_border, with_blank))
  end
end

M.fold = function(motion)
  local lnum = fn.line('.') --[[@as integer]]
  local sel_start = fn.line('v')
  local lev = fn.foldlevel(lnum)
  local levp = fn.foldlevel(lnum - 1)
  -- Multi-line selection with cursor on top of selection
  if sel_start > lnum then
    return (lev == 0 and 'zk' or lev > levp and levp > 0 and 'k' or '')
      .. vim.v.count1
      .. (motion == 'i' and ']zkV[zj' or ']zV[z')
  end
  return (lev == 0 and 'zj' or lev > levp and 'j' or '')
    .. vim.v.count1
    .. (motion == 'i' and '[zjV]zk' or '[zV]z')
end

M.buffer = buffer
M.codeblock_i = codeblock_fn(false)
M.codeblock_a = codeblock_fn(true)
M.comment = comment
M.indent_i = indent_fn(false, false)
M.indent_I = indent_fn(false, true)
M.indent_a = indent_fn(true, false)
M.indent_A = indent_fn(true, true)

return M
