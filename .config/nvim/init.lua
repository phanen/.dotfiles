vim.loader.enable() -- https://github.com/neovim/neovim/pull/24044

if vim.g.vscode then
  -- no ftplugins/plugins/...
  vim.cmd [[filetype plugin indent off]]
  vim.go.loadplugins = false
  return vim.fn['vscode#setup']()
end

_G.api = vim.api
_G.env = vim.env
_G.fn = vim.fn
_G.fs = vim.fs
_G.g = vim.g
_G.lsp = vim.lsp
_G.uv = vim.uv or vim.loop
_G.u = require('ulib')
_G.map = u.map

vim.ui = u.patch.ui
vim.text = u.patch.text
vim.lsp.util.locations_to_items = u.patch.lsp.util.locations_to_items

package.path = table.concat({
  package.path,
  env.HOME .. '/.luarocks/share/lua/5.1/?/init.lua',
  env.HOME .. '/.luarocks/share/lua/5.1/?.lua',
  './lua/?.lua',
}, ';')

g.mapleader = ' '
g.maplocalleader = '+'
g.markdown_recommended_style = 0 -- disable some builtin ftplugin features
g.no_man_maps = 1 -- use fastmove, don't use gj/gk
g.term_shell = 'fish'
g.config_path = vim.fn.stdpath('config') ---@as string
g.state_path = vim.fn.stdpath('state') ---@as string
g.cache_path = vim.fn.stdpath('cache') ---@as string
g.data_path = vim.fn.stdpath('data') ---@as string
g.run_path = vim.fn.stdpath('run') ---@as string
g.lazy_path = vim.g.data_path .. '/lazy/lazy.nvim' ---@type string
g.docs_path = vim.g.state_path .. '/lazy/docs'
g.lock_path = vim.g.data_path .. '/lazy-lock.json'
g.dev_path = '~/b'
g.nvim_root = vim.env.HOME .. '/b/neovim'
g.local_path = vim.g.state_path .. '/local.lua'
g.border = { '┏', '━', '┓', '┃', '┛', '━', '┗', '┃' }
g.indentsym = '|'

require 'hl'
require 'opt'
require 'map'
require 'pm'
