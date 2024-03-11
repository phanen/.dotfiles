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
_G.vget = vim.fn.getregion
    and function()
      local text = vim.fn.getregion(vim.fn.getpos ".", vim.fn.getpos "v", { type = vim.fn.mode() })
      vim.api.nvim_feedkeys(k "<esc>", "x", false)
      return text
    end
  or function()
    local save_a = vim.fn.getreg "a"
    vim.fn.setreg("a", {})
    -- do nothing in normal mode
    vim.cmd [[noau normal! "ay\<esc\>]]
    local sel_text = vim.fn.getreg "a"
    vim.fn.setreg("a", save_a)
    return { sel_text }
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
    { import = "plugins.edit" },
    { import = "plugins.git" },
    { import = "plugins.lsp" },
    { import = "plugins.misc" },
    { import = "plugins.pick" },
    { import = "plugins.ts" },
  },
  defaults = { lazy = true },
  change_detection = { notify = false },
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

-- vim.g.colors_name = "vim"
vim.cmd.colorscheme "tokyonight"
