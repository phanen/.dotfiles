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
