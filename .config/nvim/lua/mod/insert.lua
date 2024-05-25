local M = {}

local regex_keyword_at_beginning = vim.regex([=[^\s*[[:keyword:]]*]=])
local regex_nonkeyword_at_beginning = vim.regex([=[^\s*[^[:keyword:] ]*]=])
local regex_keyword_at_end = vim.regex([=[[[:keyword:]]*\s*$]=])
local regex_nonkeyword_at_end = vim.regex([=[[^[:keyword:] ]*\s*$]=])

local str_isempty = function(str) return str:gsub('%s+', '') == '' end

---@param str string
---@vararg vim.regex compiled vim regex
---@return string
local match_nonempty = function(str, ...)
  local patterns = { ... }
  local capture = ''
  for _, pattern in ipairs(patterns) do
    local match_start, match_end = pattern:match_str(str)
    capture = match_start and str:sub(match_start + 1, match_end) or capture
    if not str_isempty(capture) then return capture end
  end
  return capture
end

---Get current line
---@return string
local get_current_line = function()
  return fn.mode() == 'c' and fn.getcmdline() or api.nvim_get_current_line()
end

---Get current column number
---@return integer
local get_current_col = function() return fn.mode() == 'c' and fn.getcmdpos() or fn.col('.') end

---Get character relative to cursor
---@param offset number from cursor
---@return string character
local get_char = function(offset)
  local idx = get_current_col() + offset
  return get_current_line():sub(idx, idx)
end

---Get word after cursor
---@param str string? content of the line, default to current line
---@param colnr integer? column number, default to current column
---@return string
local get_word_after = function(str, colnr)
  str = str or get_current_line()
  colnr = colnr or get_current_col()
  return match_nonempty(str:sub(colnr), regex_keyword_at_beginning, regex_nonkeyword_at_beginning)
end

---Get word before cursor
---@param str string? content of the line, default to current line
---@param colnr integer? column number, default to current column - 1
---@return string
local get_word_before = function(str, colnr)
  str = str or get_current_line()
  colnr = colnr or get_current_col() - 1
  return match_nonempty(str:sub(1, colnr), regex_keyword_at_end, regex_nonkeyword_at_end)
end

local last_line = function() return fn.mode() == 'c' or fn.line('.') == fn.line('$') end
local first_line = function() return fn.mode() == 'c' or fn.line('.') == 1 end
local end_of_line = function() return get_current_col() == #get_current_line() + 1 end
local start_of_line = function() return get_current_col() == 1 end

local mid_of_line = function()
  local current_col = get_current_col()
  return current_col > 1 and current_col <= #get_current_line()
end

local forward_word = function()
  local word_after = get_word_after()
  if not str_isempty(word_after) or fn.mode() == 'c' then
    return string.rep('<right>', #word_after)
  end
  -- No word after cursor and is in insert mode
  local current_linenr = fn.line('.')
  local target_linenr = fn.nextnonblank(current_linenr + 1)
  target_linenr = target_linenr ~= 0 and target_linenr or fn.line('$')
  local line_str = fn.getline(target_linenr) --[[@as string]]
  return (current_linenr == target_linenr and '' or '<home>')
    .. string.rep('<down>', target_linenr - current_linenr)
    .. string.rep('<right>', #get_word_after(line_str, 1))
end

local backward_word = function()
  local word_before = get_word_before()
  if not str_isempty(word_before) or fn.mode() == 'c' then
    return string.rep('<left>', #word_before)
  end
  -- No word before cursor and is in insert mode
  local current_linenr = fn.line('.')
  local target_linenr = fn.prevnonblank(current_linenr - 1)
  target_linenr = target_linenr ~= 0 and target_linenr or 1
  local line_str = fn.getline(target_linenr) --[[@as string]]
  return (current_linenr == target_linenr and '' or '<end>')
    .. string.rep('<up>', current_linenr - target_linenr)
    .. string.rep('<left>', #get_word_before(line_str, #line_str))
end

local forward_char = function()
  if last_line() and end_of_line() then return '<ignore>' end
  return end_of_line() and '<down><home>' or '<right>'
end

local backward_char = function()
  if first_line() and start_of_line() then return '<ignore>' end
  return start_of_line() and '<up><end>' or '<left>'
end

local kill_word = function()
  return (fn.mode() == 'c' and '' or '<C-g>u') .. string.rep('<Del>', #get_word_after())
end

local kill_line = function()
  return '<c-g>u' .. (end_of_line() and '<del>' or '<cmd>normal! D<cr><right>')
end

local swap_char = function()
  if fn.getcmdtype():match('[?/]') then return '<c-t>' end
  if start_of_line() and not first_line() then
    local char_under_cur = get_char(0)
    if char_under_cur ~= '' then
      return '<del><up><end>' .. char_under_cur .. '<down><home>'
    else
      local lnum = fn.line('.')
      local prev_line = fn.getline(lnum - 1) --[[@as string]]
      local char_end_of_prev_line = prev_line:sub(-1)
      if char_end_of_prev_line ~= '' then
        return '<up><end><bs><down><home>' .. char_end_of_prev_line
      end
      return ''
    end
  end
  if end_of_line() then
    local char_before = get_char(-1)
    if get_char(-2) ~= '' or fn.mode() == 'c' then
      return '<bs><left>' .. char_before .. '<end>'
    else
      return '<bs><up><end>' .. char_before .. '<down><end>'
    end
  end
  if mid_of_line() then return '<bs><right>' .. get_char(-1) end
end

local unix_line_discard = function()
  if not start_of_line() then fn.setreg('-', get_current_line():sub(1, get_current_col() - 1)) end
  return fn.mode() == 'c' and '<c-u>' or '<c-g>u<c-u>'
end

local ic = function(...) map('!', ...) end
local i = function(...) map('i', ...) end
local c = function(...) map('c', ...) end

local setup_cmap = function()
  local u = require('lib.keymap')
  u.cmap(':', 'lua ')
  u.cabbr('man', 'Man')
  u.cabbr('ht', 'hor te')
  u.cabbr('vt', 'vert te')
  u.cabbr('ep', 'e%:p:h')
  u.cabbr('vep', 'vs%:p:h')
  u.cabbr('sep', 'sp%:p:h')
  u.cabbr('tep', 'tabe%:p:h')
  u.cabbr('rm', '!rm')
  u.cabbr('mv', '!mv')
  u.cabbr('git', '!git')
  u.cabbr('mkd', '!mkdir')
  u.cabbr('mkdir', '!mkdir')
  u.cabbr('touch', '!touch')

  u.cabbr('Q', "((getcmdtype()  is# ':' && getcmdline() is# 'Q')?('q'):('Q'))", { expr = true })
  u.cabbr('%H', "expand('%:p:h')", { expr = true })
  u.cabbr('%P', "expand('%:p')", { expr = true })
  u.cabbr('%T', "expand('%:t')", { expr = true })
  u.cabbr("w'", 'w', {})
end

-- TODO: some time c-w not work the right sep? (for readline.nvim)
-- fastmove for readline?
M.setup = function()
  if vim.g.loaded_readline then return end
  vim.g.loaded_readline = true

  ic('<c-p>', '<up>', { remap = true })
  ic('<c-n>', '<down>', { remap = true })
  i('<down>', '<cmd>norm! g<down><cr>')
  i('<up>', '<cmd>norm! g<up><cr>')

  ic('<c-f>', '<right>')
  ic('<c-b>', '<left>')
  -- i('<c-b>', backward_char, { expr = true })
  -- i('<c-f>', forward_char, { expr = true })

  ic('<c-a>', require('readline').dwim_beginning_of_line)
  ic('<c-e>', '<end>')

  -- TODO: more sep, _-
  ic('<c-j>', require('readline').forward_word)
  ic('<c-o>', require('readline').backward_word)
  -- ic('<c-o>', backward_word, { expr = true })
  -- ic('<c-j>', forward_word, { expr = true })

  -- TODO: kill next line
  -- ic('<c-l>', require('readline').kill_word)
  ic('<c-l>', kill_word, { expr = true })

  ic('<c-k>', require('readline').kill_line)
  i('<c-k>', kill_line, { expr = true })
  c('<c-k>', '<c-\\>e(strpart(getcmdline(), 0, getcmdpos() - 1))<cr>')

  ic('<c-u>', unix_line_discard, { expr = true })

  -- ic('<c-e>', 'pumvisible() ? "<c-e>" : "<end>"', { expr = true, replace_keycodes = false })
  -- FIXME: ignore indent
  -- ic('<c-y>', 'pumvisible() ? "<c-y>" : "<c-r>-"', { expr = true, replace_keycodes = false })

  -- ic('<c-t>', swap_char, { expr = true })
  -- ic('<c-d>', '<del>')

  -- backup
  -- c('<c-_>', '<c-f>')
  -- FIXME: flash.nvim cannot used in here
  -- c('<m-f>', '<c-f>')

  -- FIXME: c-w is override? when open help
  ic('<c-bs>', '<c-w>')

  -- register play
  -- FIXME: don't show leader
  -- TODO: a editable dashbord maybe better
  -- unknown: let @"=2, don't work for `p`
  ic("<c-r>'", '<c-r>"')
  i('<c-g><c-l>', '<c-x><c-l>')
  i('<c-g>+', '<esc>[szg`]a')
  i('<c-g>=', '<c-g>u<esc>[s1z=`]a<c-g>u')

  -- abbr
  map('!a', 'ture', 'true')
  map('!a', 'Ture', 'True')
  map('!a', 'flase', 'false')
  map('!a', 'fasle', 'false')
  map('!a', 'Flase', 'False')
  map('!a', 'Fasle', 'False')
  map('!a', 'lcaol', 'local')
  map('!a', 'lcoal', 'local')
  map('!a', 'locla', 'local')
  map('!a', 'sahre', 'share')
  map('!a', 'saher', 'share')
  map('!a', 'balme', 'blame')

  setup_cmap()

  -- -- tabout
  -- ic('<Tab>', function() require('mod.tabout').jump(1) end)
  -- ic('<S-Tab>', function() require('mod.tabout').jump(-1) end)

  -- TODO: expandtab???
end

return M
