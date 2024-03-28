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
g.docs_path = fs.joinpath(g.state_path, 'lazy', 'docs')
g.lazy_path = fs.joinpath(g.data_path, 'lazy')

require 'opt'
require 'map'
require 'au'
require 'pm'

-- g.colors_name = "vim"
pcall(vim.cmd.colorscheme, 'tokyonight')
