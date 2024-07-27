-- TODO: module path
-- https://stackoverflow.com/questions/60283272/how-to-get-the-exact-path-to-the-script-that-was-loaded-in-lua
DEBUG = 1

local eval = function(f_or_v, ...)
  if vim.is_callable(f_or_v) then return f_or_v(...) end
  return f_or_v
end

-- lazy require:
--    require a module -> create a metatable under mt_reg
--    wrap the origin module's functions and values
--    the cost is `call_stack_level++` for every access on average
--    which is accpetable for most cases

-- module should have been loaded if we run `{u,_G}.mod.x(...)`
-- g_ver: hot update module
--   if mod is unloaded: reference on mod.key -> wrapped
--   mod is as global
--   __call:
-- k_ver: hot update module.curtain_key one by one
--   if key is "unused": reference on mod.key -> wrapped
--   mod is as local
--   __call:

-- zen:
-- concurency -> no
-- require -> loaded

-- TODO: usable in most case
_G.lazy_reg = {}
local lazy_require = function(path)
  -- break consistancy
  local loaded = package.loaded[path]
  if loaded then return loaded end

  local lazy_loaded = lazy_reg[path]
  if lazy_loaded then return lazy_loaded end

  local lazy_mod = setmetatable({}, {
    __index = function(_, k)
      -- if hot updated (occurred after this key's reference)
      -- local mod = rawget(self, k)
      -- if mod then return mod end
      return function(...) -- all mod.key is updated after `require`
        lazy_reg[path] = nil -- then use package.loaded
        return eval(require(path)[k], ...)
      end
    end,

    -- cannot determine if mod/mod.key callable ahead of time
    -- if mod is callable: passthrough it...
    -- if mod.key is callable:
    __call = function(_, ...)
      lazy_reg[path] = nil
      return eval(require(path), ...)
    end,
  })
  lazy_reg[path] = lazy_mod
  return lazy_mod
end

local r = lazy_require

-- https://github.com/neovim/neovim/pull/27216
-- TODO: 似乎结果上差距不大, 但是明显在 map 那边都加载了
-- _G.u = setmetatable({
--   upd = function(old, new) vim.tbl_deep_extend('force', old or {}, new or {}) end,
--   r = r,
--   eval = eval,
--   tu = r 'nvim-treesitter.ts_utils',
--   tc = r 'nvim-treesitter.configs',
--   ts = r 'vim.treesitter',
--
--   -- defered modules
--   buf = nil, ---@module 'lib.buf'
--   smart = nil, ---@module 'lib.smart'
--   qf = nil, ---@module 'lib.qf'
--   misc = nil, ---@module 'lib.misc'
--   util = nil, ---@module 'lib.util'
--   git = nil, ---@module 'lib.git'
--   textobj = nil, ---@module 'lib.textobj'
-- }, {
--   __index = function(t, k)
--     t[k] = require('lib.' .. k)
--     return t[k]
--   end,
-- })

_G.u = setmetatable({
  -- top functions
  upd = function(old, new) vim.tbl_deep_extend('force', old or {}, new or {}) end,
  r = r,
  eval = eval,
  tu = r 'nvim-treesitter.ts_utils',
  tc = r 'nvim-treesitter.configs',
  ts = r 'vim.treesitter',

  -- defered modules
  buf = nil, ---@module 'lib.buf'
  smart = nil, ---@module 'lib.smart'
  qf = nil, ---@module 'lib.qf'
  misc = nil, ---@module 'lib.misc'
  util = nil, ---@module 'lib.util'
  git = nil, ---@module 'lib.git'
  textobj = nil, ---@module 'lib.textobj'
}, {
  __index = function(_, k) return lazy_require('lib.' .. k) end,
})

_G.api = vim.api
_G.fn = vim.fn
_G.uv = vim.uv or vim.loop
_G.fs = vim.fs

_G.g = vim.g
_G.a = vim.api
_G.env = vim.env

-- TOD: curry...
_G.map = setmetatable({}, {
  ---map.n map.nx
  ---@param v string
  __index = function(t, v)
    t[v] = function(...) vim.keymap.set(vim.split(v, ''), ...) end
    return t[v]
  end,
  __call = function(_, ...) return vim.keymap.set(...) end,
})

-- TODO: deprecate map by map.xx
_G.n = map.n
_G.x = map.x
_G.nx = map.nx

-- require'nvim-treesitter.install'.commands.TSInstall.run('bash')
_G.lsp = vim.lsp

-- _G.o = vim.opt

-- make it simple...
_G.ferr = function(msg, ...) vim.api.nvim_err_writeln(msg:format(...)) end
_G.fwarn = function(msg, ...) vim.api.nvim_echo({ { msg:format(...), 'WarningMsg' } }, true, {}) end
_G.finff = function(msg, ...) vim.api.nvim_echo({ { msg:format(...), 'MoreMsg' } }, true, {}) end

_G.cmd = api.nvim_create_user_command
_G.ag = api.nvim_create_augroup

---@param group string
---@vararg { [1]: string|string[], [2]: vim.api.keyset.create_autocmd }
---@return integer?
_G.augroup = function(group, ...)
  if g['disable_' .. group] then return end
  local id = ag(group, { clear = true })
  for _, a in ipairs { ... } do
    a[2].group = id
    au(unpack(a))
  end
  return id
end

-- TODO: this allow reload... at least
-- _G.au = api.nvim_create_autocmd
local grp = ag('Conf', { clear = true })
_G.au = function(ev, opts)
  opts = opts or {}
  opts.group = opts.group or grp -- we cannot use clear here
  api.nvim_create_autocmd(ev, opts)
end

g.config_path = fn.stdpath('config') ---@as string
g.state_path = fn.stdpath('state') ---@as string
g.cache_path = fn.stdpath('cache') ---@as string
g.data_path = fn.stdpath('data') ---@as string
g.run_path = fn.stdpath('run') ---@as string

-- env.NVIM_NONF = true
-- env.NVIM_NO3RD

env.COLORTERM = 256

-- g.border = 'rounded'
-- g.border = { '┏', '━', '┓', '┃', '┛', '━', '┗', '┃' }
g.border = { '┌', '─', '┐', '│', '┘', '─', '└', '│' }

g.has_ui = #api.nvim_list_uis() > 0
g.has_gui = fn.has('gui_running') == 1
g.modern_ui = g.has_ui and env.DISPLAY ~= nil

-- FIXME(?): env is ''? nil?
g.no_nf = not g.modern_ui or env.NVIM_NONF or false
g.no_3rd = not g.modern_ui or env.NVIM_NO3RD or false

-- fuck
FASTER = false
if FASTER then
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.validate = function(...) end
  g.lazy_shada = true
  g.disable_intro = true
end

g.disable_intro = true

g.disable_AutoCwd = true

-- seems resolved(?): https://github.com/ibhagwan/fzf-lua/discussions/1296
g.disable_cache_docs = false

g.disable_Autosave = true

g.vendor_bar = true
