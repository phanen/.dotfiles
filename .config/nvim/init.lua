vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = "+"

_G.map = vim.keymap.set

_G.req = function(path)
  return setmetatable({}, {
    __index = function(_, k)
      return function(...) return require(path)[k](...) end
    end,
  })
end

_G.getvisual = function()
  local save_a = vim.fn.getreg "a"
  vim.fn.setreg("a", {})
  -- do nothing in normal mode
  vim.cmd [[noau normal! "ay\<esc\>]]
  local sel_text = vim.fn.getreg "a"
  vim.fn.setreg("a", save_a)
  return sel_text
end

require "opt"
require "map"
require "au"

vim.env.LAZYROOT = vim.fn.stdpath "data" .. "/lazy"
local path = vim.env.LAZYROOT .. "/lazy.nvim"
if not vim.uv.fs_stat(path) then
  vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", "https://github.com/folke/lazy.nvim", path }
end

vim.opt.rtp:prepend(path)
require("lazy").setup {
  spec = {
    { import = "plugins.cmp" },
    { import = "plugins.dap" },
    { import = "plugins.edit" },
    { import = "plugins.lsp" },
    { import = "plugins.misc" },
    { import = "plugins.pick" },
    { import = "plugins.ts" },
  },
  defaults = { lazy = true },
  change_detection = { notify = false },
  performance = {
    rtp = {
      paths = { vim.fn.stdpath "data" .. "/site" },
      disabled_plugins = {
        "matchit",
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

-- vim.g.colors_name = "vim"
vim.cmd.colorscheme "tokyonight"
