vim.g.config_path = vim.fn.stdpath('config') ---@as string
vim.g.state_path = vim.fn.stdpath('state') ---@as string
vim.g.cache_path = vim.fn.stdpath('cache') ---@as string
vim.g.data_path = vim.fn.stdpath('data') ---@as string

vim.g.border = 'rounded'
-- { '┏', '━', '┓', '┃', '┛', '━', '┗', '┃' }

-- experiemental
_G.cfg = {
  path = {
    config = vim.g.config_path,
    state = vim.g.stage_path,
    cache = vim.g.cache_path,
    data = vim.g.data_path,
    extra_plugins = ...,
  },
  ui = { border = 'rounded' },
}

local group = vim.api.nvim_create_augroup('Conf', { clear = true })

_G.map = vim.keymap.set
_G.cmd = vim.api.nvim_create_user_command
_G.au = function(ev, opts)
  opts = opts or {}
  opts.group = opts.group or group
  vim.api.nvim_create_autocmd(ev, opts)
end

_G.r = require
-- _G.r = setmetatable({}, { __index = function(_, k) return require(k) end })

_G.req = function(_path)
  return setmetatable({}, {
    __index = function(_, k) return require(_path)[k] end,
  })
end

_G.api = vim.api
_G.fn = vim.fn
_G.uv = vim.uv or vim.loop

-- _G.lsp = vim.lsp
-- _G.ts = vim.ts

if vim.fn.has('nvim-0.10') == 0 then
  ---@diagnostic disable: duplicate-set-field
  vim.uv = vim.uv or vim.loop
  vim.fs.joinpath = function(...) return (table.concat({ ... }, '/'):gsub('//+', '/')) end
  vim.keycode = function(str) return vim.api.nvim_replace_termcodes(str, true, true, true) end
else
  vim.keymap.del('n', '<c-w>d')
  vim.keymap.del('n', '<c-w><c-d>')
end
