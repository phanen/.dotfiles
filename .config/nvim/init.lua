vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = "+"

_G.au = vim.api.nvim_create_autocmd
_G.fmt = string.format
_G.k = function(str) return vim.api.nvim_replace_termcodes(str, true, true, true) end
_G.map = vim.keymap.set
_G.req = function(path)
  return setmetatable({}, {
    __index = function(_, k)
      return function(...) return require(path)[k](...) end
    end,
  })
end
_G.vget = req("utils").vget

_G.n = function(...) map("n", ...) end
_G.x = function(...) map("x", ...) end
_G.nx = function(...) map({ "n", "x" }, ...) end
_G.ox = function(...) map({ "o", "x" }, ...) end
_G.ic = function(...) map("!", ...) end

require "opt"
require "map"
require "au"

local root = vim.fn.stdpath "data" .. "/lazy"
local path = root .. "/lazy.nvim"
if not vim.uv.fs_stat(path) then
  vim.fn.system { "git", "clone", "--branch=stable", "https://github.com/folke/lazy.nvim", path }
end

vim.opt.rtp:prepend(path)
require("lazy").setup {
  spec = {
    { import = "plugins.cmp" },
    { import = "plugins.edit" },
    { import = "plugins.git" },
    { import = "plugins.lsp" },
    { import = "plugins.misc" },
    { import = "plugins.pick" },
    { import = "plugins.ts" },
  },
  defaults = { lazy = true },
  change_detection = { notify = false },
  git = { filter = false }, -- blame it
  dev = { path = "~/b", patterns = { "phanen" }, fallback = true },
  performance = {
    rtp = {
      disabled_plugins = {
        "matchit",
        "matchparen",
        "netrwPlugin",
        "nvim",
        "osc52",
        "rplugin",
        "shada",
        "spellfile",
        "tohtml",
        "tutor",
      },
    },
  },
}

au("User", {
  pattern = { "LazySync" },
  callback = function(_) end,
})

-- vim.g.colors_name = "vim"
vim.cmd.colorscheme "tokyonight"
