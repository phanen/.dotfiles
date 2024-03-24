vim.loader.enable()
-- vim.go.loadplugins = false

_G.config_path = vim.fn.stdpath('data')

vim.g.mapleader = ' '
vim.g.maplocalleader = '+'

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

require 'opt'
require 'map'
require 'au'
require 'pm'

-- vim.g.colors_name = "vim"
pcall(vim.cmd.colorscheme, 'tokyonight')
