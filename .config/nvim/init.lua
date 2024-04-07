vim.loader.enable()

vim.g.mapleader = ' '
vim.g.maplocalleader = '+'

_G.map = vim.keymap.set

-- vim.go.loadplugins = false
require 'pat'
require 'opt'
require 'map'
require 'au'
require 'pm'

for dir, type in vim.fs.dir(vim.g.color_path) do
  if type == 'directory' then
    vim.opt.rtp:append(vim.fs.joinpath(vim.g.color_path, dir))
  end
end

pcall(vim.cmd.colorscheme, vim.g.colors_name)
