vim.loader.enable()
vim.g.mapleader = " "
vim.g.maplocalleader = "+"

_G.map = vim.keymap.set

require "opt"
require "map"
require "lsp"

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

-- TODO: async install missing
require("lazy").setup {
  spec = { import = "plugins" },
  defaults = { lazy = true },
  change_detection = { notify = false },
  checker = { concurrency = 30 },
  performance = {
    rtp = {
      paths = { vim.fn.stdpath "data" .. "/site" },
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  dev = { path = vim.fn.stdpath "data" .. "/lazy/local", fallback = false },
}

-- filter down a quickfix list
-- vim.cmd.packadd "cfilter"
if vim.fn.getenv "SSH_TTY" ~= vim.NIL then vim.cmd.colorscheme "dracula" end
-- vim.cmd("set bg=" .. vim.fn.system "darkman get")
