_G.api = vim.api
_G.fn = vim.fn
_G.uv = vim.uv or vim.loop

_G.g = vim.g
_G.a = vim.api
_G.env = vim.env

-- _G.o = vim.opt

_G.map = vim.keymap.set
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
local group = ag('Conf', { clear = true })
_G.au = function(ev, opts)
  opts = opts or {}
  opts.group = opts.group or group -- we cannot use clear here
  api.nvim_create_autocmd(ev, opts)
end

_G.r = function(path)
  return setmetatable({}, {
    __index = function(_, k)
      return function(...) require(path)[k](...) end
    end,
  })
end

-- _G.u = setmetatable({}, { __index = function(_, k) return require('lib.' .. k) end })
_G.n = function(...) map('n', ...) end
_G.x = function(...) map('x', ...) end
_G.nx = function(...) map({ 'n', 'x' }, ...) end

_G.tu = r 'nvim-treesitter.ts_utils'
_G.tc = r 'nvim-treesitter.configs'
_G.ts = r 'vim.treesitter'
-- require'nvim-treesitter.install'.commands.TSInstall.run('bash')
_G.lsp = vim.lsp

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

g.vendor_bar = false

local get_parser = vim.treesitter.get_parser
---@diagnostic disable-next-line: duplicate-set-field
vim.treesitter.get_parser = function(bufnr, lang, opts)
  if bufnr == nil or bufnr == 0 then bufnr = api.nvim_get_current_buf() end
  if
      (function()
        if vim.bo[bufnr].ft == 'tex' then return true end
        return api.nvim_buf_line_count(bufnr) > 100000
      end)()
  then
    error('skip treesitter for large buf')
  end
  return get_parser(bufnr, lang, opts)
end
