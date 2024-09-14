-- this module should be registered in the global scope as 'u'

local U = {}

local r = require('ulib._r')
local m = require('ulib._m')
local p = r.req('ulib._p') ---@module 'ulib._p'

setmetatable(U, {
  ---@param t table<string, any>
  ---@param modname string
  __index = function(t, modname)
    local v = r.req('ulib.' .. modname)
    rawset(t, modname, v)
    return v
  end,
})

-- export
U.req = r.req
U.lreq = r.lreq
U.xreq = r.xreq
U.aug = m.augroup
U.com = m.command
U.map = m.map
U.pp = p.pp
U.p1 = p.p1
U.print = p.print
U.cat = p.cat

U.eval = function(v, ...)
  if vim.is_callable(v) then return v(...) end
  return v
end

--- @vararg table deep merge applied from left to right (left-associative)
--- treat `vim.islist` element as trivial val (override left one by deepcopied right one)
U.merge = function(...) return vim.tbl_deep_extend('force', ...) end

return U
