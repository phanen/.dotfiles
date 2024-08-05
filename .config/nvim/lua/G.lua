local vim_fn = setmetatable({}, {
  --- @param t table<string,function>
  --- @param key string
  --- @return function
  __index = function(t, key)
    local fn = function(...) return vim.call(key, ...) end
    t[key] = fn
    return fn
  end,
})

_G.api = vim.api
_G.fn = vim_fn or vim.fn
_G.uv = vim.uv or vim.loop
_G.fs = vim.fs
_G.lsp = vim.lsp

_G.g = vim.g
_G.env = vim.env

-- TODO: curry...
_G.map = setmetatable({}, {
  ---@param k string
  __index = function(t, k)
    local f = function(...) vim.keymap.set(vim.split(k, ''), ...) end
    rawset(t, k, f)
    return f
  end,
  __call = function(_, ...) return vim.keymap.set(...) end,
})

map.n('<c-s><c-d>', '<cmd>mksession! /tmp/reload.vim | cq!123<cr>')

_G.cmd = vim.api.nvim_create_user_command
_G.ag = vim.api.nvim_create_augroup

---@param group string
---@vararg { [1]: string|string[], [2]: vim.api.keyset.create_autocmd }
---@return integer?
_G.augroup = function(group, ...)
  if g['disable_' .. group] then return end
  local id = ag(group, { clear = true })
  for _, a in ipairs { ... } do
    a[2].group = id
    autocmd(unpack(a))
  end
  return id
end

-- `clear` -> reloadable
-- _G.au = api.nvim_create_autocmd
local grp = ag('Conf', { clear = true })
_G.autocmd = function(ev, opts)
  opts = opts or {}
  opts.group = opts.group or grp -- we cannot use clear here
  vim.api.nvim_create_autocmd(ev, opts)
end

-- one more step from https://github.com/neovim/neovim/pull/27216
local lazy_reg = {}
_G.u = setmetatable({
  lazy_reg = lazy_reg,
  eval = function(v, ...)
    if vim.is_callable(v) then return v(...) end
    return v
  end,

  ---lazy_require:
  ---   create a metatable under lazy_reg
  ---   the cost is `stacklevel++`
  ---   in early reference
  ---   which is accpetable for most cases
  ---@param modname string
  ---@return table
  lazy_req = function(modname)
    -- local loaded = package.loaded[path]
    local lazy_loaded = lazy_reg[modname]
    if lazy_loaded then return lazy_loaded end
    local lazy_mod = setmetatable({}, {
      __index = function(self, k)
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
  end,

  -- override defaults
  -- vim.print('') -> linebreak
  -- vim.print('a', 'b') -> "a\nb"
  -- u.print() -> linebreak
  ---@return nil
  print = function(...)
    -- note: both `#{...}` and `ipairs{...}` not work as expected
    local n = select('#', ...)
    if n == 0 then return print('\n') end
    local tbl = {}
    -- local pack = { ... }
    for i = 1, n do
      -- local v = pack[i]
      local v = select(i, ...)
      if type(v) == 'nil' then
        tbl[#tbl + 1] = 'nil'
      else
        tbl[#tbl + 1] = vim.inspect(v)
      end
    end
    return print(table.concat(tbl, ' '))
  end,

  -- defered modules
  -- TODO: @module typing, lsp @
  -----@source lib/buffer.lua
  buf = nil, ---@module 'lib.buf'
  bufop = nil, ---@module 'lib.bufop'
  colors = nil, ---@module 'lib.colors'
  comment = nil, ---@module 'lib.comment'
  debug = nil, ---@module 'lib.debug'
  export = nil, ---@module 'lib.export'
  fs = nil, ---@module 'lib.fs'
  git = nil, ---@module 'lib.git'
  gitlink = nil, ---@module 'lib.gitlink'
  gx = nil, ---@module 'lib.gx'
  hl = nil, ---@module 'lib.hl'
  json = nil, ---@module 'lib.json'
  keymap = nil, ---@module 'lib.keymap'
  lazy = nil, ---@module 'lib.lazy'
  log = nil, ---@module 'lib.log'
  misc = nil, ---@module 'lib.misc'
  msg = nil, ---@module 'lib.msg'
  qf = nil, ---@module 'lib.qf'
  smart = nil, ---@module 'lib.smart'
  stl = nil, ---@module 'lib.stl'
  string = nil, ---@module 'lib.string'
  textobj = nil, ---@module 'lib.textobj'
  treesitter = nil, ---@module 'lib.treesitter'
  util = nil, ---@module 'lib.util'
}, {
  ---lazy_req, but adapted to use module under 'lib' by default
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
    rawset(u, key, mod)
    return mod
  end,
})

u.tu = u.lazy_req 'nvim-treesitter.ts_utils'
u.tc = u.lazy_req 'nvim-treesitter.configs'
u.ts = u.lazy_req 'vim.treesitter'
