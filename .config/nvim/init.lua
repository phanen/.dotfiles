--  _ __ | |__   __ _ _ __ (_)_   _ _ __ ___
-- | '_ \| '_ \ / _` | '_ \| | | | | '_ ` _ \
-- | |_) | | | | (_| | | | | | |_| | | | | | |
-- | .__/|_| |_|\__,_|_| |_|_|\__,_|_| |_| |_|
-- |_|
assert(vim.loop.os_uname().sysname == "Linux")

vim.g.mapleader = " "
vim.g.maplocalleader = ","

_G.map = vim.keymap.set
_G.P = vim.print

for _, source in ipairs {
  "options",
  "mappings",
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

-- WIP: navie config parser
local f = assert(io.open(vim.fn.stdpath "config" .. "/theme", "r"))
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

if vim.g.started_by_firenvim then
  vim.o.laststatus = 0

  vim.g.firenvim_config = {
    localSettings = {
      [".*"] = { cmdline = "none" },
      ["https?://www.google.com"] = { takeover = "never", priority = 1 },
    },
  }

  vim.cmd [[
    au BufEnter leetcode*.txt set filetype=rust
    au BufEnter *ipynb*.txt set filetype=python
    au BufEnter github.com_*.txt set filetype=markdown
    " auto insert
    au FocusGained * startinsert
  ]]

  vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
    nested = true,
    command = "write",
  })
end

-- vim.cmd("set bg=" .. vim.fn.system("darkman get"))
