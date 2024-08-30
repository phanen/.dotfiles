-- https://github.com/neovim/neovim/pull/24044
vim.loader.enable()

-- TODO: module path
-- https://stackoverflow.com/questions/60283272/how-to-get-the-exact-path-to-the-script-that-was-loaded-in-lua

-- vim.go.loadplugins = true

if vim.g.vscode then
  require 'opt'
  -- require 'map'
  vim.fn['vscode#setup']()
  require 'mod.vscode'
  return
end

vim.api.nvim_set_keymap('n', '<c-s><c-d>', '<cmd>up | mks! /tmp/reload.vim | cq!123<cr>', {})

require 'G'

require 'opt'
require 'au'
require 'map'
require 'cmd'
-- note: lazy.nvim will override `require`
require 'pm'

-- modules not explictly lazy-loaded
require 'mod.idl'
require 'mod.runner'
require 'mod.colors'

-- pcall(vim.cmd.colorscheme, vim.g.colors_name)
-- TODO: template system
-- TODO: lib better to be independent
-- TODO: 'lewis6991/hover.nvim'
