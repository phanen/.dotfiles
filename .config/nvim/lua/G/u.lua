local U = {
  -- TODO: not sure how to typing these
  eval = ..., ---@type function
  lazy_req = ..., ---@type function
  lazy_reg = ..., ---@type table to check what we've register

  cache = ..., ---@type table

  tu = ..., ---@type table
  tc = ..., ---@type table
  ts = ..., ---@type table

  -- defered modules (TODO: @module typing, lsp @)
  buf = nil, ---@module 'lib.buf'   -- @source lib/buf.lua
  bufop = nil, ---@module 'lib.bufop'
  colors = nil, ---@module 'lib.colors'
  comment = nil, ---@module 'lib.comment'
  debug = nil, ---@module 'lib.debug'
  export = nil, ---@module 'lib.export'
  fs = nil, ---@module 'lib.fs'
  git = nil, ---@module 'lib.git'
  gx = nil, ---@module 'lib.gx'
  gl = nil, ---@module 'lib.gl'
  hl = nil, ---@module 'lib.hl'
  keymap = nil, ---@module 'lib.keymap'
  lazy = nil, ---@module 'lib.lazy'
  log = nil, ---@module 'lib.log'
  lsp = nil, ---@module 'lib.lsp'
  misc = nil, ---@module 'lib.misc'
  msg = nil, ---@module 'lib.msg'
  qf = nil, ---@module 'lib.qf'
  smart = nil, ---@module 'lib.smart'
  stl = nil, ---@module 'lib.stl'
  string = nil, ---@module 'lib.string'
  textobj = nil, ---@module 'lib.textobj'
  treesitter = nil, ---@module 'lib.treesitter'
}

-- one more step from https://github.com/neovim/neovim/pull/27216
-- also lazy on key (side effect is )
setmetatable(U, {
  ---`lib_lazy_req`, like lazy_req, but adapted to use module under 'lib' by default
  ---cache in global u
  __index = function(_, key)
    local path = 'lib.' .. key
    local mod = setmetatable({}, {
      __index = function(self, k)
        return function(...)
          local v = require(path)[k]
          if type(v) == 'function' then
            rawset(self, k, v)
            return v(...)
          end
          rawset(self, k, function() return v end)
          return v
        end
      end,
      __call = function(_, ...)
        local mod = require(path)
        local mt = getmetatable(mod)
        if mt and mt.__call then return mod(...) end
        return mod
      end,
    })
    rawset(U, key, mod)
    return mod
  end,
})

---lazy require:
---   create a metatable under lazy_reg
---   the cost is `stacklevel++`
---   in early reference
---   which is accpetable for most cases
U.lazy_reg, U.lazy_req = (function()
  local lazy_reg = {}
  return lazy_reg,
    ---@param modname string
    ---@return table
    function(modname)
      -- local loaded = package.loaded[path]
      local lazy_loaded = lazy_reg[modname]
      if lazy_loaded then return lazy_loaded end
      local lazy_mod = setmetatable({}, {
        __index = function(self, k)
          -- require('fidget').notify(('%s.%s'):format(modname, k))
          return function(...)
            local v = require(modname)[k] -- reduce stacklevel in the next reference
            if type(v) == 'function' then
              rawset(self, k, v)
              return v(...)
            end
            rawset(self, k, function() return v end)
            return v
          end
        end,
        __call = function(_, ...)
          local mod = require(modname)
          local mt = getmetatable(mod)
          if mt and mt.__call then return mod(...) end
          return mod
        end,
      })
      rawset(lazy_reg, modname, lazy_mod)
      return lazy_mod
    end
end)()

U.tu = U.lazy_req 'nvim-treesitter.ts_utils'
U.tc = U.lazy_req 'nvim-treesitter.configs'
U.ts = U.lazy_req 'vim.treesitter'

-- override defaults
-- vim.print('') -> linebreak
-- vim.print('a', 'b') -> "a\nb"
-- u.print() -> linebreak
---@return nil
U.print = function(...)
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
      tbl[#tbl + 1] = vim.inspect(v) -- TODO: quote is unneeded (inline mode for table/ prefer inline)
    end
  end
  return print(table.concat(tbl, ' '))
end

U.eval = function(v, ...)
  if vim.is_callable(v) then return v(...) end
  return v
end

U.tu = U.lazy_req 'nvim-treesitter.ts_utils'
U.tc = U.lazy_req 'nvim-treesitter.configs'
U.ts = U.lazy_req 'vim.treesitter'

-- func = cache_tablize(func), -> func[one_arg_only]
---@generic T
---@param cb fun(...): T
---@return table<string|number, T>
---@see vim.func.__memoize
U.cache_tablize = function(cb)
  return setmetatable({}, {
    __index = function(t, key)
      local v = cb(key)
      rawset(t, key, v)
      return v
    end,
  })
end

-- it provide hash = resolve_hash(hash) to give key
---@generic T
---@param cb fun(...): T
---@param hash fun(...): string|number
---@return fun(...): T
---@see vim.func.__memoize
U.cache_hash = function(cb, hash)
  local f = U.cache_tablize(cb)
  return function(...)
    if hash then
      local key = hash(...)
      return f[key]
    end
    -- local first = ...
    return f[...]
  end
end

---@generic T
---@param cb fun(): T
---@return fun(): T
U.cache_one = function(cb)
  local cache
  return function()
    if cache then return cache end
    cache = cb()
    return cache
  end
end

U.cat = function(path)
  local content = u.fs.read_file(path)
  if content then
    print(content)
  else
    print('file not found:', path)
  end
end

return U
