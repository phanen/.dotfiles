-- 'chrisgrieser/nvim-various-textobjs'
local M = {}

local options = {
  lookForwardSmall = 10,
  lookForwardBig = 30,
}

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

---@alias pos {[1]: integer, [2]: integer}

---Sets the selection for the textobj (characterwise)
---@param s pos
---@param e pos
function M.charwise(s, e)
  if not s or not e then return end
  vim.cmd.normal { 'm`', bang = true } -- save last position in jumplist
  api.nvim_win_set_cursor(0, s)
  if fn.mode():find('v') then
    vim.cmd.normal { 'o', bang = true }
  else
    vim.cmd.normal { 'v', bang = true }
  end
  api.nvim_win_set_cursor(0, e)
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

---Seek and select characterwise a text object based on one pattern.
---CAVEAT multi-line-objects are not supported.
---INFO Exposed for creation of custom textobjs, but subject to change without notice.
---@param pattern string lua pattern. REQUIRES two capture groups marking the
---two additions for the outer variant of the textobj. Use an empty capture group
---when there is no difference between inner and outer on that side.
---Basically, the two capture groups work similar to lookbehind/lookahead for the
---inner selector.
---@param scope "inner"|"outer"
---@param lookForwL integer
---@return pos? startPos
---@return pos? endPos
---@nodiscard
function M.searchTextobj(pattern, scope, lookForwL)
  local cursorRow, cursorCol = unpack(api.nvim_win_get_cursor(0))
  local lineContent = api.nvim_buf_get_lines(0, cursorRow - 1, cursorRow, true)[1]
  local lastLine = api.nvim_buf_line_count(0)
  local beginCol = 0 ---@type number|nil
  local endCol, captureG1, captureG2, noneInStartingLine

  -- first line: check if standing on or in front of textobj
  repeat
    beginCol = beginCol + 1
    beginCol, endCol, captureG1, captureG2 = lineContent:find(pattern, beginCol)
    noneInStartingLine = not beginCol
    local standingOnOrInFront = endCol and endCol > cursorCol
  until standingOnOrInFront or noneInStartingLine

  -- subsequent lines: search full line for first occurrence
  local linesSearched = 0
  if noneInStartingLine then
    while true do
      linesSearched = linesSearched + 1
      if linesSearched > lookForwL or cursorRow + linesSearched > lastLine then return end
      lineContent =
        api.nvim_buf_get_lines(0, cursorRow + linesSearched - 1, cursorRow + linesSearched, true)[1]

      beginCol, endCol, captureG1, captureG2 = lineContent:find(pattern)
      if beginCol then break end
    end
  end

  -- capture groups determine the inner/outer difference
  -- INFO :find() returns integers of the position if the capture group is empty
  if scope == 'inner' then
    local frontOuterLen = type(captureG1) ~= 'number' and #captureG1 or 0
    local backOuterLen = type(captureG2) ~= 'number' and #captureG2 or 0
    beginCol = beginCol + frontOuterLen
    endCol = endCol - backOuterLen
  end

  local startPos = { cursorRow + linesSearched, beginCol - 1 }
  local endPos = { cursorRow + linesSearched, endCol - 1 }
  return startPos, endPos
end

---searches for the position of one or multiple patterns and selects the closest one
---INFO Exposed for creation of custom textobjs, but subject to change without notice.
---@param patterns string|string[] lua, pattern(s) with the specification from `searchTextobj`
---@param scope "inner"|"outer"
---@param lookForwL integer
---@return boolean -- whether textobj search was successful
function M.selectTextobj(patterns, scope, lookForwL)
  local closestObj

  if type(patterns) == 'string' then
    local startPos, endPos = M.searchTextobj(patterns, scope, lookForwL)
    if startPos and endPos then closestObj = { startPos, endPos } end
  elseif type(patterns) == 'table' then
    local closestRow = math.huge
    local shortestDist = math.huge
    local cursorCol = api.nvim_win_get_cursor(0)[2]

    for _, pattern in ipairs(patterns) do
      local startPos, endPos = M.searchTextobj(pattern, scope, lookForwL)
      if startPos and endPos then
        local row, startCol = unpack(startPos)
        local distance = startCol - cursorCol
        local isCloserInRow = distance < shortestDist

        -- INFO Here, we cannot simply use the absolute value of the distance.
        -- If the cursor is standing on a big textobj A, and there is a
        -- second textobj B which starts right after the cursor, A has a
        -- high negative distance, and B has a small positive distance.
        -- Using simply the absolute value to determine the which obj is the
        -- closer one would then result in B being selected, even though the
        -- idiomatic behavior in vim is to always select an obj the cursor
        -- is standing on before seeking forward for a textobj.
        local cursorOnCurrentObj = (distance < 0)
        local cursorOnClosestObj = (shortestDist < 0)
        if cursorOnCurrentObj and cursorOnClosestObj then
          isCloserInRow = distance > shortestDist
        end

        -- this condition for rows suffices since `searchTextobj` does not
        -- return multi-line-objects
        if (row < closestRow) or (row == closestRow and isCloserInRow) then
          closestRow = row
          shortestDist = distance
          closestObj = { startPos, endPos }
        end
      end
    end
  end

  if closestObj then
    local startPos, endPos = unpack(closestObj)
    M.charwise(startPos, endPos)
    return true
  end
  return false
end

---@param scope "inner"|"outer" outer includes trailing -_
function M.subword(scope)
  local pattern = {
    '()%w[%l%d]+([_%- ]?)', -- camelCase or lowercase
    '()%u[%u%d]+([_%- ]?)', -- UPPER_CASE
    '()%d+([_%- ]?)', -- number
  }
  M.selectTextobj(pattern, scope, 0)
end

function M.toNextClosingBracket()
  local pattern = '().([]})])'

  local _, endPos = M.searchTextobj(pattern, 'inner', options.lookForwardSmall)
  if not endPos then return end
  local startPos = api.nvim_win_get_cursor(0)

  M.charwise(startPos, endPos)
end

function M.toNextQuotationMark()
  -- char before quote must not be escape char. Using `vim.opt.quoteescape` on
  -- the off-chance that the user has customized this.
  local quoteEscape = vim.opt_local.quoteescape:get() -- default: \
  local pattern = ([[()[^%s](["'`])]]):format(quoteEscape)

  local _, endPos = M.searchTextobj(pattern, 'inner', options.lookForwardSmall)
  if not endPos then return end
  local startPos = api.nvim_win_get_cursor(0)

  M.charwise(startPos, endPos)
end

---@param scope "inner"|"outer"
function M.anyQuote(scope)
  -- INFO char before quote must not be escape char. Using `vim.opt.quoteescape` on
  -- the off-chance that the user has customized this.
  local escape = vim.opt_local.quoteescape:get() -- default: \
  local patterns = {
    ('^(").-[^%s](")'):format(escape), -- ""
    ("^(').-[^%s](')"):format(escape), -- ''
    ('^(`).-[^%s](`)'):format(escape), -- ``
    ('([^%s]").-[^%s](")'):format(escape, escape), -- ""
    ("([^%s]').-[^%s](')"):format(escape, escape), -- ''
    ('([^%s]`).-[^%s](`)'):format(escape, escape), -- ``
  }

  M.selectTextobj(patterns, scope, options.lookForwardSmall)

  -- pattern accounts for escape char, so move to right to account for that
  local isAtStart = api.nvim_win_get_cursor(0)[2] == 1
  if scope == 'outer' and not isAtStart then vim.cmd.normal { 'ol', bang = true } end
end

---@param scope "inner"|"outer"
function M.anyBracket(scope)
  local patterns = {
    '(%().-(%))', -- ()
    '(%[).-(%])', -- []
    '({).-(})', -- {}
  }
  M.selectTextobj(patterns, scope, options.lookForwardSmall)
end

---near end of the line, ignoring trailing whitespace
---(relevant for markdown, where you normally add a -space after the `.` ending a sentence.)
function M.nearEoL()
  local pattern = '().(%S%s*)$'

  local _, endPos = M.searchTextobj(pattern, 'inner', 0)
  if not endPos then return end
  local startPos = api.nvim_win_get_cursor(0)

  M.charwise(startPos, endPos)
end

---current line (but characterwise)
---@param scope "inner"|"outer" outer includes indentation and trailing spaces
function M.lineCharacterwise(scope)
  -- FIX being on NUL, see #108 and #109
  -- (Not sure why this only happens for `lineCharacterwise` though…)
  -- `col()` results in "true" char, as it factors in Tabs
  local isOnNUL = #api.nvim_get_current_line() < fn.col('.')
  if isOnNUL then vim.cmd.normal { 'g_', bang = true } end

  local pattern = '^(%s*).-(%s*)$'
  M.selectTextobj(pattern, scope, 0)
end

---similar to https://github.com/andrewferrier/textobj-diagnostic.nvim
---requires builtin LSP
---@param wrap "wrap"|"nowrap"
function M.diagnostic(wrap)
  -- INFO for whatever reason, diagnostic line numbers and the end column (but
  -- not the start column) are all off-by-one…

  -- HACK if cursor is standing on a diagnostic, get_prev() will return that
  -- diagnostic *BUT* only if the cursor is not on the first character of the
  -- diagnostic, since the columns checked seem to be off-by-one as well m(
  -- Therefore counteracted by temporarily moving the cursor
  vim.cmd.normal { 'l', bang = true }
  local prevD = vim.diagnostic.get_prev { wrap = false }
  vim.cmd.normal { 'h', bang = true }

  local nextD = vim.diagnostic.get_next { wrap = (wrap == 'wrap') }
  local curStandingOnPrevD = false -- however, if prev diag is covered by or before the cursor has yet to be determined
  local curRow, curCol = unpack(api.nvim_win_get_cursor(0))

  if prevD then
    local curAfterPrevDstart = (curRow == prevD.lnum + 1 and curCol >= prevD.col)
      or (curRow > prevD.lnum + 1)
    local curBeforePrevDend = (curRow == prevD.end_lnum + 1 and curCol <= prevD.end_col - 1)
      or (curRow < prevD.end_lnum)
    curStandingOnPrevD = curAfterPrevDstart and curBeforePrevDend
  end

  local target = curStandingOnPrevD and prevD or nextD
  if target then
    M.charwise({ target.lnum + 1, target.col }, { target.end_lnum + 1, target.end_col - 1 })
  else
  end
end

---@param scope "inner"|"outer" inner value excludes trailing commas or semicolons, outer includes them. Both exclude trailing comments.
function M.value(scope)
  -- captures value till the end of the line
  -- negative sets and frontier pattern ensure that equality comparators ==, !=
  -- or css pseudo-elements :: are not matched
  local pattern = '(%s*%f[!<>~=:][=:]%s*)[^=:].*()'

  local startPos, endPos = M.searchTextobj(pattern, scope, options.lookForwardSmall)
  if not startPos or not endPos then return end

  -- if value found, remove trailing comment from it
  local curRow = startPos[1]
  local lineContent = api.nvim_buf_get_lines(0, curRow - 1, curRow, true)[1]
  if vim.bo.commentstring ~= '' then -- JSON has empty commentstring
    local commentPat = vim.bo.commentstring:gsub(' ?%%s.*', '') -- remove placeholder and backside of commentstring
    commentPat = vim.pesc(commentPat) -- escape lua pattern
    commentPat = ' *' .. commentPat .. '.*' -- to match till end of line
    lineContent = lineContent:gsub(commentPat, '') -- remove commentstring
  end
  local valueEndCol = #lineContent - 1

  -- inner value = exclude trailing comma/semicolon
  if scope == 'inner' and lineContent:find('[,;]$') then valueEndCol = valueEndCol - 1 end

  -- set selection
  endPos[2] = valueEndCol
  M.charwise(startPos, endPos)
end

---@param scope "inner"|"outer" outer key includes the `:` or `=` after the key
function M.key(scope)
  local pattern = '()%S.-( ?[:=] ?)'
  M.selectTextobj(pattern, scope, options.lookForwardSmall)
end

---@param scope "inner"|"outer" inner number consists purely of digits, outer number factors in decimal points and includes minus sign
function M.number(scope)
  -- Here two different patterns make more sense, so the inner number can match
  -- before and after the decimal dot. enforcing digital after dot so outer
  -- excludes enumrations.
  local pattern = scope == 'inner' and '%d+' or '%-?%d*%.?%d+'
  M.selectTextobj(pattern, 'outer', options.lookForwardSmall)
end

-- INFO mastodon URLs contain `@`, neovim docs urls can contain a `'`, special
-- urls like https://docs.rs/regex/1.*/regex/#syntax can have a `*`
function M.url()
  M.selectTextobj("%l%l%l-://[A-Za-z0-9_%-/.#%%=?&'@+*:]+", 'outer', options.lookForwardBig)
end

---see #26
---@param scope "inner"|"outer" inner excludes the leading dot
function M.chainMember(scope)
  local patterns = {
    '([:.])[%w_][%a_]-%b()()', -- with call
    '([:.])[%w_][%a_]*()', -- without call
  }
  M.selectTextobj(patterns, scope, options.lookForwardSmall)
end

function M.lastChange()
  local changeStartPos = api.nvim_buf_get_mark(0, '[')
  local changeEndPos = api.nvim_buf_get_mark(0, ']')

  if changeStartPos[1] == changeEndPos[1] and changeStartPos[2] == changeEndPos[2] then return end

  M.charwise(changeStartPos, changeEndPos)
end

--------------------------------------------------------------------------------
-- FILETYPE SPECIFIC TEXTOBJS

---@param scope "inner"|"outer" inner link only includes the link title, outer link includes link, url, and the four brackets.
function M.mdlink(scope)
  local pattern = '(%[)[^%]]-(%]%b())'
  M.selectTextobj(pattern, scope, options.lookForwardSmall)
end

---@param scope "inner"|"outer" inner selector only includes the content, outer selector includes the type.
function M.mdEmphasis(scope)
  -- CAVEAT this still has a few edge cases with escaped markup, will need a
  -- treesitter object to reliably account for that.
  local patterns = {
    '([^\\]%*%*?).-[^\\](%*%*?)', -- * or **
    '([^\\]__?).-[^\\](__?)', -- _ or __
    '([^\\]==).-[^\\](==)', -- ==
    '([^\\]~~).-[^\\](~~)', -- ~~
    '(^%*%*?).-[^\\](%*%*?)', -- * or **
    '(^__?).-[^\\](__?)', -- _ or __
    '(^==).-[^\\](==)', -- ==
    '(^~~).-[^\\](~~)', -- ~~
  }
  M.selectTextobj(patterns, scope, options.lookForwardSmall)

  -- pattern accounts for escape char, so move to right to account for that
  local isAtStart = api.nvim_win_get_cursor(0)[2] == 1
  if scope == 'outer' and not isAtStart then vim.cmd.normal { 'ol', bang = true } end
end

---@param scope "inner"|"outer" inner selector excludes the brackets themselves
function M.doubleSquareBrackets(scope)
  local pattern = '(%[%[).-(%]%])'
  M.selectTextobj(pattern, scope, options.lookForwardSmall)
end

---@param scope "inner"|"outer" outer selector includes trailing comma and whitespace
function M.cssSelector(scope)
  local pattern = '()[#.][%w-_]+(,? ?)'
  M.selectTextobj(pattern, scope, options.lookForwardSmall)
end

---@param scope "inner"|"outer" inner selector is only the value of the attribute inside the quotation marks.
function M.htmlAttribute(scope)
  local pattern = {
    '([%w-]+=").-(")',
    "([%w-]+=').-(')",
  }
  M.selectTextobj(pattern, scope, options.lookForwardSmall)
end

---@param scope "inner"|"outer" outer selector includes the pipe
function M.shellPipe(scope)
  local patterns = {
    '()[^|%s][^|]-( ?| ?)', -- trailing pipe, 1st char non-space to exclude indentation
    '( ?| ?)[^|]*()', -- leading pipe
  }
  M.selectTextobj(patterns, scope, options.lookForwardSmall)
end

---@param scope "inner"|"outer" inner selector only affects the color value
function M.cssColor(scope)
  local pattern = {
    '(#)' .. ('%x'):rep(6) .. '()', -- #123456
    '(#)' .. ('%x'):rep(3) .. '()', -- #123
    '(hsla?%()[%%%d,./deg ]-(%))', -- hsl(123, 23, 23) or hsl(123deg, 123%, 123% / 100)
    '(rgba?%()[%d,./ ]-(%))', -- rgb(123, 123, 123) or rgb(50%, 50%, 50%)
  }
  M.selectTextobj(pattern, scope, options.lookForwardSmall)
end

--------------------------------------------------------------------------------
return M
