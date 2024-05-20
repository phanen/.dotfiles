local is_blank = function(lnum)
  local pattern = '^%s*$'
  local line = api.nvim_buf_get_lines(0, lnum - 1, lnum, true)[1]
  return line:find(pattern) ~= nil
end

local is_comment = function(lnum)
  local pattern = '^%s*' .. vim.pesc(vim.bo.commentstring):gsub(' ?%%%%s ?', '.*') .. '%s*$'
  local line = api.nvim_buf_get_lines(0, lnum - 1, lnum, true)[1]
  return line:find(pattern) ~= nil
end

---@param match fun(lnum: integer)
---@param n integer?
---@return integer|nil, integer|nil # todo: stupid
local get_matched_lines = function(match, n)
  if not n then n = math.huge end
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
  return prev + 1, next - 1
end

---@param outer boolean?
local md_codeblock = function(outer)
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

---@param include_pre? boolean
---@param include_after? boolean
---@param include_blank? boolean
local indentation = function(include_pre, include_after, include_blank)
  local cur, last = fn.line('.'), fn.line('$')
  while is_blank(cur) do
    if last == cur then return end
    cur = cur + 1
  end
  local indent = fn.indent(cur)
  local prev, next = cur - 1, cur + 1
  while prev > 0 and ((include_blank and is_blank(prev)) or fn.indent(prev) >= indent) do
    prev = prev - 1
  end
  while next <= last and ((include_blank and is_blank(next)) or fn.indent(next) >= indent) do
    next = next + 1
  end
  if not include_pre then prev = prev + 1 end
  if not include_after then next = next - 1 end
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
  if not fn.mode():find('V') then api.nvim_feedkeys('V', 'x', true) end
  api.nvim_feedkeys('o', 'x', false)
  fn.cursor(e, 0)
end

local ox = function(...) map({ 'o', 'x' }, ...) end

ox('iq', '<cmd>lua require("various-textobjs").anyQuote("inner")<cr>')
ox('aq', '<cmd>lua require("various-textobjs").anyQuote("outer")<cr>')

ox('il', '<cmd>lua require("various-textobjs").lineCharacterwise("inner")<cr>')

ox('iu', '<cmd>lua require("various-textobjs").url()<cr>')

ox('in', 'iB')
ox('an', 'aB')
ox('in', '<cmd>lua require("various-textobjs").anyBracket("inner")<cr>')
ox('an', '<cmd>lua require("various-textobjs").anyBracket("outer")<cr>')

ox('id', '<cmd>lua require("various-textobjs").diagnostic("wrap")<cr>')

ox('ig', function() linewise(1, fn.line('$')) end)

ox('ic', function()
  if vim.bo.commentstring == '' then return end
  linewise(get_matched_lines(is_comment))
end)

-- from other providers
ox('ih', ':<c-u>Gitsigns select_hunk<cr>')

au('FileType', {
  pattern = 'markdown',
  callback = function(ev)
    -- ox('i<c-e>', function() linewise(md_codeblock()) end, { buffer = ev.buf })
    -- ox('a<c-e>', function() linewise(md_codeblock(true)) end, { buffer = ev.buf })
    ox(
      'i<c-e>',
      '<cmd>lua require("various-textobjs").mdFencedCodeBlock("inner")<cr>',
      { buffer = ev.buf }
    )
    ox(
      'a<c-e>',
      '<cmd>lua require("various-textobjs").mdFencedCodeBlock("outer")<cr>',
      { buffer = ev.buf }
    )
  end,
})

ox('ii', function()
  if api.nvim_get_current_line():match('%s*') then
    linewise(indentation(false, false, true))
  else
    if fn.indent('.') == 0 then
      linewise(1, fn.line('$'))
    else
      linewise(indentation(true, true, false))
    end
  end
end)

ox('ai', function()
  if api.nvim_get_current_line():match('%s*') then
    linewise(indentation(true, true, true))
  else
    if fn.indent('.') == 0 then
      linewise(1, fn.line('$'))
    else
      linewise(indentation(true, true, false))
    end
  end
end)
