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

_G.cmd = vim.api.nvim_create_user_command
_G.ag = vim.api.nvim_create_augroup

_G.map = require('G.m')
_G.u = require('G.u')

---@param group string
---@vararg { [1]: string|string[], [2]: vim.api.keyset.create_autocmd }
---@return integer?
_G.augroup = function(group, ...)
  if g['disable_' .. group] then return end
  local id = ag(group, {}) -- clear previous group by default
  for _, a in ipairs { ... } do
    a[2].group = id
    autocmd(unpack(a))
  end
  return id
end

-- TODO:
_G.augroup2 = setmetatable({}, {
  __index = function(_, group) return ag(group, {}) end,
  __newindex = function(_, group, spec)
    ag(group, { clear = true })
    assert(type(spec) == 'table')
    if group == 'table' then
    end
  end,
})

-- `clear` -> reloadable
-- _G.au = api.nvim_create_autocmd
local grp = ag('Conf', { clear = true })
_G.autocmd = function(ev, opts)
  opts = opts or {}
  opts.group = opts.group or grp -- we cannot use clear here
  vim.api.nvim_create_autocmd(ev, opts)
end

require 'G.g'
require 'G.patch'
