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
  -- PERF: expandable?
  -- if current region is the same as last region, then trigger expand version
  -- like vip ip ip ...

  if not s or not e then return end
  vim.cmd.normal { 'm`', bang = true }
  fn.cursor(s, 0)

  if not fn.mode():find('V') then
    vim.cmd.normal { 'V', bang = true }
    -- api.nvim_feedkeys('V', 'x', true)
  end
  -- api.nvim_feedkeys('o', 'x', false)
  vim.cmd.normal { 'o', bang = true }
  fn.cursor(e, 0)
end

local buffer = function() linewise(1, fn.line('$')) end

local codeblock = function(outer)
  return function() linewise(region_codeblock(outer)) end
end

local comment = function()
  if vim.bo.commentstring == '' then return end
  linewise(region_match(is_comment))
end

-- lower/upper: with blank or not
local indent = function(with_border, with_blank)
  return function()
    -- if at top level, then same as
    if fn.indent('.') == 0 then return linewise(region_match(not_blank)) end
    return linewise(region_indent(with_border, with_border, with_blank))
  end
end

M.fold = function(motion)
  local lnum = vim.fn.line('.') --[[@as integer]]
  local sel_start = vim.fn.line('v')
  local lev = vim.fn.foldlevel(lnum)
  local levp = vim.fn.foldlevel(lnum - 1)
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

---Go to the first line of current paragraph
---@return nil
function M.goto_paragraph_firstline()
  local chunk_size = 10
  local linenr = vim.fn.line('.')
  local count = vim.v.count1

  -- If current line is the first line of paragraph, move one line
  -- upwards first to goto the first line of previous paragraph
  if linenr >= 2 then
    local lines = vim.api.nvim_buf_get_lines(0, linenr - 2, linenr, false)
    if lines[1]:match('^$') and lines[2]:match('%S') then linenr = linenr - 1 end
  end

  while linenr >= 1 do
    local chunk =
      vim.api.nvim_buf_get_lines(0, math.max(0, linenr - chunk_size - 1), linenr - 1, false)
    for i, line in ipairs(vim.iter(chunk):rev():totable()) do
      local current_linenr = linenr - i
      if line:match('^$') then
        count = count - 1
        if count <= 0 then
          vim.cmd.normal({ "m'", bang = true })
          vim.cmd(tostring(current_linenr + 1))
          return
        end
      elseif current_linenr <= 1 then
        vim.cmd.normal({ "m'", bang = true })
        vim.cmd('1')
        return
      end
    end
    linenr = linenr - chunk_size
  end
end

---Go to the last line of current paragraph
---@return nil
function M.goto_paragraph_lastline()
  local chunk_size = 10
  local linenr = vim.fn.line('.')
  local buf_line_count = vim.api.nvim_buf_line_count(0)
  local count = vim.v.count1

  -- If current line is the last line of paragraph, move one line
  -- downwards first to goto the last line of next paragraph
  if buf_line_count - linenr >= 1 then
    local lines = vim.api.nvim_buf_get_lines(0, linenr - 1, linenr + 1, false)
    if lines[1]:match('%S') and lines[2]:match('^$') then linenr = linenr + 1 end
  end

  while linenr <= buf_line_count do
    local chunk = vim.api.nvim_buf_get_lines(0, linenr, linenr + chunk_size, false)
    for i, line in ipairs(chunk) do
      local current_linenr = linenr + i
      if line:match('^$') then
        count = count - 1
        if count <= 0 then
          vim.cmd.normal({ "m'", bang = true })
          vim.cmd(tostring(current_linenr - 1))
          return
        end
      elseif current_linenr >= buf_line_count then
        vim.cmd.normal({ "m'", bang = true })
        vim.cmd(tostring(buf_line_count))
        return
      end
    end
    linenr = linenr + chunk_size
  end
end

M.buffer = buffer
M.codeblock = codeblock
M.comment = comment
M.indent = indent
M.indent_i = indent(false, false)
M.indent_I = indent(false, true)
M.indent_a = indent(true, false)
M.indent_A = indent(true, true)

return M
