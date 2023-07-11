--  _ __ | |__   __ _ _ __ (_)_   _ _ __ ___
-- | '_ \| '_ \ / _` | '_ \| | | | | '_ ` _ \
-- | |_) | | | | (_| | | | | | |_| | | | | | |
-- | .__/|_| |_|\__,_|_| |_|_|\__,_|_| |_| |_|
-- |_|
assert(vim.loop.os_uname().sysname == 'Linux')

vim.g.mapleader = " "
vim.g.maplocalleader = ","

_G.map = vim.keymap.set
_G.P = vim.print

for _, source in ipairs {
  "mappings",
  "options",
  "commands",
} do
  local ok, fault = pcall(require, source)
  if not ok then vim.api.nvim_err_writeln("Failed to load " .. source .. "\n\n" .. fault) end
end

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- vim.o.completeopt = "menuone,noselect,noinsert"

-- WIP: navie config parser
local f = assert(io.open(vim.fn.expand "$XDG_CONFIG_HOME" .. "/nvim/theme", "r"))
local color_name = f:read "*all"
f:close()

require("lazy").setup("plugins", {
  defaults = { lazy = true },
  change_detection = { notify = false },
  checker = {
    enabled = false,
    concurrency = 30,
    notify = false,
    frequency = 3600,
  },
  install = {
    missing = true,
    colorscheme = { color_name, "nightfox", "tokyonight", "habamax", "default" },
  },
  performance = {
    rtp = {
      paths = { vim.fn.stdpath "data" .. "/site" },
      disabled_plugins = { "netrw", "netrwPlugin" },
    },
  },
  -- dev = {
  --   path = require("utils").dev_dir,
  -- },
})

-- filter down a quickfix list
-- vim.cmd.packadd "cfilter"

vim.cmd("colorscheme " .. color_name)
-- vim.cmd("set bg=" .. fn.system("darkman get"))
