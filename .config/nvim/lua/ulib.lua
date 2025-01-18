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
U.pp1 = p.pp1
U.print = p.print
U.cat = p.cat

U.eval = function(v, ...)
  if vim.is_callable(v) then return v(...) end
  return v
end

--- @vararg table deep merge applied from left to right (left-associative)
--- treat `vim.islist` element as trivial val (override left one by deepcopied right one)
U.merge = function(...) return vim.tbl_deep_extend('force', ...) end

U.extend = function(...)
  local ret = {}
  for _, tbl in ipairs { ... } do
    for k, v in pairs(tbl) do
      ret[k] = v
    end
  end
  return ret
end

-- fn_with
U.func_with = function(func, with)
  return function() return func(with) end
end

U.tbl_key_flatten = function(val)
  if type(val) ~= 'table' then return val end
  for k, v in pairs(val) do
    if type(k) == 'string' then
      local a, b = k:match('^([^%.]-)%.(.+)$')
      if a and b then
        val[a], val[k] = U.tbl_key_flatten { [b] = v }, nil
      else
        val[k] = U.tbl_key_flatten(v)
      end
    end
  end
  return val
end

local function make_dot_repeatable(func)
  _G._nvim_treesitter_textobject_last_function = func
  vim.o.opfunc = 'v:lua._nvim_treesitter_textobject_last_function'
  api.nvim_feedkeys('g@l', 'n', false)
end
return U
