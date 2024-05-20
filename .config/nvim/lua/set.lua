vim.g.config_path = vim.fn.stdpath('config') ---@as string
vim.g.state_path = vim.fn.stdpath('state') ---@as string
vim.g.cache_path = vim.fn.stdpath('cache') ---@as string
vim.g.data_path = vim.fn.stdpath('data') ---@as string

-- vim.g.border = 'rounded'
vim.g.border = { '┏', '━', '┓', '┃', '┛', '━', '┗', '┃' }

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

-- _G.r = require
_G.r = setmetatable({}, { __index = function(_, k) return require(k) end })

-- TODO: error handler
---@module "util"
_G.m = setmetatable({}, {
  __index = function(_, path)
    return setmetatable({}, {
      __index = function(_, k)
        -- benchmark
        -- return ([[<cmd>lua r('%s').%s()<cr>]]):format(path, k)
        return function(v) return r(path)[k](v) end
      end,
    })
  end,
})

_G.r = function(_path)
  return setmetatable({}, {
    __index = function(_, k) return require(_path)[k] end,
  })
end

_G.api = vim.api
_G.a = vim.api
_G.fn = vim.fn
_G.uv = vim.uv or vim.loop

_G.u = setmetatable({}, {
  __index = function(_, k) return require('lib.' .. k) end,
})

_G.n = function(...) map('n', ...) end
_G.x = function(...) map('x', ...) end
_G.nx = function(...) map({ 'n', 'x' }, ...) end

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

vim.tbl_add_reverse_lookup = function(o)
  for _, k in ipairs(vim.tbl_keys(o)) do
    local v = o[k]
    if o[v] then
      error(
        string.format(
          'The reverse lookup found an existing value for %q while processing key %q',
          tostring(v),
          tostring(k)
        )
      )
    end
    o[v] = k
  end
  return o
end

_G.tu = r 'nvim-treesitter.ts_utils'
_G.tc = r 'nvim-treesitter.configs'
_G.ts = vim.treesitter
-- require'nvim-treesitter.install'.commands.TSInstall.run('bash')
