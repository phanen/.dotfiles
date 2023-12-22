vim.g.mapleader = " "
vim.g.maplocalleader = "+"

_G.map = vim.keymap.set
_G.P = vim.print

for _, source in ipairs {
  "opt",
  "map",
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

-- TODO: async install missing
require("lazy").setup("plugins", {
  defaults = { lazy = true },
  change_detection = { notify = false },
  ui = {
    border = "rounded",
  },
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
})

-- filter down a quickfix list
-- vim.cmd.packadd "cfilter"
if vim.fn.getenv "SSH_TTY" ~= vim.NIL then vim.cmd.colorscheme "dracula" end
-- vim.cmd("set bg=" .. vim.fn.system "darkman get")
