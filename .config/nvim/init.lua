vim.loader.enable()

-- vim.go.loadplugins = true
require 'set'
require 'opt'
if vim.g.vscode then return require('mod.vscode') end
require 'au'
require 'ft'
require 'map'
require 'cmd'
require 'pm'

require 'mod.fastmove'
require 'mod.session'
require 'mod.textobj'
require 'mod.readline'
require 'mod.indentline'
require 'mod.fmt'
-- require 'mod.bench'

pcall(vim.cmd.colorscheme, vim.g.colors_name)
