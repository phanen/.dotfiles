vim.g.config_path = vim.fn.stdpath('config') ---@as string
vim.g.state_path = vim.fn.stdpath('state') ---@as string
vim.g.cache_path = vim.fn.stdpath('cache') ---@as string
vim.g.data_path = vim.fn.stdpath('data') ---@as string

vim.g.border = 'rounded'
-- { '┏', '━', '┓', '┃', '┛', '━', '┗', '┃' }

local group = vim.api.nvim_create_augroup('Conf', { clear = true })

_G.map = vim.keymap.set

_G.au = function(ev, opts)
  opts = opts or {}
  opts.group = opts.group or group
  vim.api.nvim_create_autocmd(ev, opts)
end

_G.r = setmetatable({}, { __index = function(_, k) return require(k) end })

_G.u = setmetatable({}, { __index = function(_, k) return require('util')[k] end })

if vim.fn.has('nvim-0.10') == 0 then
  ---@diagnostic disable: duplicate-set-field
  vim.uv = vim.uv or vim.loop
  function vim.fs.joinpath(...) return (table.concat({ ... }, '/'):gsub('//+', '/')) end
  function vim.keycode(str) return vim.api.nvim_replace_termcodes(str, true, true, true) end
else
  vim.keymap.del('n', '<c-w>d')
  vim.keymap.del('n', '<c-w><c-d>')
end
