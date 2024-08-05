-- https://github.com/neovim/neovim/pull/24044
vim.loader.enable()

-- TODO: module path
-- https://stackoverflow.com/questions/60283272/how-to-get-the-exact-path-to-the-script-that-was-loaded-in-lua
DEBUG = 1

-- vim.go.loadplugins = true

if vim.g.vscode then
  require 'opt'
  require 'map'
  require 'mod.vscode'
  return
end

require 'G'
require 'g'
require 'patch'
require 'opt'
require 'au'
require 'map'
require 'cmd'
-- note: lazy.nvim will override `require`
require 'pm'

-- modules not explictly lazy-loaded
require 'mod.comment'
require 'mod.diagnostic'
require 'mod.fastmove'
require 'mod.fmt'
require 'mod.idl'
require 'mod.msg'
require 'mod.runner'
require 'mod.colors'
-- pcall(vim.cmd.colorscheme, vim.g.colors_name)
