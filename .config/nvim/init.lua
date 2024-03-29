local g, fs, fn = vim.g, vim.fs, vim.fn

vim.loader.enable()
-- vim.go.loadplugins = false
g.mapleader = ' '
g.maplocalleader = '+'

vim.uv = vim.uv or vim.loop

_G.map = vim.keymap.set

_G.util = setmetatable({}, {
  __index = function(_, k)
    return function(...)
      return require('util')[k](...)
    end
  end,
})

_G.r = setmetatable({}, {
  __index = function(_, k)
    return require(k)
  end,
})

g.config_path = fn.stdpath('config')
g.data_path = fn.stdpath('data')
g.state_path = fn.stdpath('state')
g.cache_path = fn.stdpath('cache')

g.lazy_path = fs.joinpath(g.data_path, 'lazy')
g.docs_path = fs.joinpath(g.state_path, 'lazy', 'docs')
g.color_path = fs.joinpath(g.cache_path, 'fzf-lua', 'pack', 'fzf-lua', 'opt')

require 'opt'
require 'map'
require 'au'
require 'pm'

-- g.colors_name = "vim"

for dir, type in vim.fs.dir(g.color_path) do
  if type == 'directory' then
    vim.opt.rtp:append(fs.joinpath(g.color_path, dir))
  end
end
pcall(vim.cmd.colorscheme, 'tokyonight')
