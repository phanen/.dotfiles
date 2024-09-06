-- pcall(vim.cmd.colorscheme, vim.g.colors_name)
-- TODO: template system
-- TODO: lib better to be independent
-- TODO: meta layer for au/cmd
-- TODO: restart nvim but not lsp (.....overhead)
-- TODO: module path
-- TODO: qf/ll toggle
-- TODO: gr/lazygit-term-edit (also like gd)... maybe all loc relavant stuffs need rewrite
-- TODO: string one of mini.nvim
-- TODO: pager set width (lazygit)
-- TODO: bufferline don' choose right icons (e.g. .bin/vim)
-- TODO: gitsigns hunks pickers
-- https://stackoverflow.com/questions/60283272/how-to-get-the-exact-path-to-the-script-that-was-loaded-in-lua
-- https://github.com/neovim/neovim/pull/24044

vim.loader.enable()

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
require 'hi'
-- lazy.nvim append package.loaders (auto setup)
require 'pm'

-- modules not explictly lazy-loaded
require 'mod.idl'
require 'mod.runner'
require 'mod.colors'
