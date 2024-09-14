-- debug print
local P = {}

local timeout = 1000

P.pp = function(...) --
  vim.system { 'notify-send', '-t', tostring(timeout), vim.inspect(...) }
end

---colorize debug print
---path -> green
---lnum -> yellow
---mesg -> red
local colorize = function(err) return err end

local p1_done
P.p1 = function(...)
  if not p1_done then
    p1_done = true
    return vim.print(...)
  end
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
