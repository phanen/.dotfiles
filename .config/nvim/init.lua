vim.loader.enable()

vim.go.loadplugins = true

require 'pat'
require 'opt'
require 'map'
require 'au'
require 'pm'
if vim.g.vscode then require 'mod.vscode' end

pcall(vim.cmd.colorscheme, vim.g.colors_name)
