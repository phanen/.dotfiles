-- debug print
local P = {}

local timeout = 1000

---@param title string
---@param body string
---@param critical boolean?
local osc99 = function(title, body, critical)
  local urgency = critical and 2 or 1
  local msg = '\x1b]99;i=1:d=0:u=%d;%s\x1b\\'
  io.stdout:write(msg:format(urgency, title))
  msg = '\x1b]99;i=1:d=1:u=icon:p=body:u=%d:w=%s;%s\x1b\\'
  io.stdout:write(msg:format(urgency, timeout, body))
end

P.pp = function(...)
  local ret = {}
  local n = select('#', ...)
  for i = 1, n do
    ret[#ret + 1] = vim.inspect((select(i, ...)))
  end
  local msg = table.concat(ret, ' ')
  osc99('', msg)
  return ...
end

local p1_done
P.p1 = function(...)
  if p1_done then return end
  p1_done = true
  return vim.print(...)
end

local pp1_done
P.pp1 = function(...)
  if pp1_done then return end
  pp1_done = true
  return P.pp(...)
end

-- override defaults
-- vim.print('') -> linebreak
-- vim.print('a', 'b') -> "a\nb"
-- u.print() -> linebreak
---@return nil
P.print = function(...)
  -- note: both `#{...}` and `ipairs{...}` not work as expected
  local n = select('#', ...)
  if n == 0 then return print('\n') end
  local tbl = {}
  -- local pack = { ... }
  for i = 1, n do
    -- local v = pack[i]
    local v = select(i, ...) -- this will drop all val (use vim.F.pack_len(...)[i] ?)
    if type(v) == 'nil' then
      tbl[#tbl + 1] = 'nil'
    else
      -- depth newline indent process
      tbl[#tbl + 1] = vim.inspect(v) -- TODO: no quote
    end
  end
  return print(table.concat(tbl, ' '))
end

P.cat = function(path)
  local content = u.fs.read_file(path)
  if content then
    print(content)
  else
    print('file not found:', path)
  end
end

return P
