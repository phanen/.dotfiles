-- https://github.com/neovim/neovim/pull/24044
vim.loader.enable()

_G.HOOK = false

if HOOK then
  local _r = require
  require = function(modname)
    local ok, info = pcall(_r, modname)
    if not ok then _r('lib.log').warn("require '%s':\n %s\n\n", modname, info) end
  end
end
-- vim.go.loadplugins = true

require 'set'
require 'mod.session'
require 'compat'

require 'opt'
require 'au'
require 'ft'
-- vim.schedule(function() require 'map' end)
require 'map'
-- require 'cmd'
require 'pm'

pcall(vim.cmd.colorscheme, vim.g.colors_name)
