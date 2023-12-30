vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = "+"

_G.map = vim.keymap.set

require "opt"
require "map"
require "au"

if not vim.fs.joinpath then vim.fs.joinpath = function(...) return (table.concat({ ... }, "/"):gsub("//+", "/")) end end
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
  checker = { concurrency = 30 },
  performance = {
    rtp = {
      paths = { vim.fn.stdpath "data" .. "/site" },
    },
  },
}
