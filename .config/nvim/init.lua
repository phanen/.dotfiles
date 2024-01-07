vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = "+"

_G.map = vim.keymap.set

require "opt"
require "au"
require "map"

vim.fs.joinpath = function(...) return (table.concat({ ... }, "/"):gsub("//+", "/")) end
vim.env.LAZYROOT = vim.fs.joinpath(vim.fn.stdpath "data", "lazy")

local path = vim.fs.joinpath(vim.env.LAZYROOT, "lazy.nvim")
if not vim.loop.fs_stat(path) then
  vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", "https://github.com/folke/lazy.nvim", path }
end
vim.opt.rtp:prepend(path)
require("lazy").setup {
  spec = { { import = "plugins" } },
  defaults = { lazy = true },
  change_detection = { notify = false },
  performance = {
    rtp = {
      paths = { vim.fn.stdpath "data" .. "/site" },
      disabled_plugins = {
        "matchparen",
        "netrwPlugin",
        "osc52",
        "rplugin",
        "tohtml",
        "tutor",
      },
    },
  },
}

vim.g.colors_name = "vim"
