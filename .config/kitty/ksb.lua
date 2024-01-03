---@diagnostic disable: undefined-global
vim.loader.enable()

vim.g.mapleader = " "
vim.o.clipboard = "unnamedplus"
vim.o.laststatus = 2
vim.o.cmdheight = 0
vim.o.scrolloff = 999

vim.o.virtualedit = "all" -- all or onemore for correct position
vim.o.termguicolors = true -- highlight
vim.opt.shortmess:append "I" -- no intro message
vim.o.ruler = false
vim.o.scrollback = 100000
vim.o.showmode = false
vim.o.ignorecase = true
vim.o.smartcase = true
vim.opt.fillchars = { eob = " " }
vim.o.wrap = false
vim.o.report = 999999 -- arbitrary large number to hide yank messages

local join = function(...) return (table.concat({ ... }, "/"):gsub("//+", "/")) end
local root = join(vim.fn.stdpath "data", "lazy")
local plug = function(basename)
  vim.opt.rtp:prepend(join(root, basename))
  local packname = vim.fn.trim(basename, ".nvim")
  return function(opts) require(packname).setup(opts) end
end

plug "kitty-scrollback.nvim" {
  custom = function(_)
    return {
      -- keymaps_enabled = false,
      paste_window = { yank_register_enabled = false },
      restore_options = true,
      highlight_overrides = { KittyScrollbackNvimVisual = { bg = "Cyan", fg = "Black" } },
    }
  end,
}

plug "lazy.nvim" {
  {
    "folke/flash.nvim",
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end },
      { "_", mode = { "n", "x", "o" }, function() require("flash").jump() end },
      { "f", mode = { "n", "x", "o" } },
    },
    opts = { modes = { search = { enabled = false } } },
  },
  {
    "kevinhwang91/nvim-hlslens",
    keys = {
      { "n", [[<cmd>execute('normal! ' . v:count1 . 'n')<cr><cmd>lua require('hlslens').start()<cr>zz]] },
      { "N", [[<cmd>execute('normal! ' . v:count1 . 'N')<cr><cmd>lua require('hlslens').start()<cr>zz]] },
      { "*", [[*<cmd>lua require('hlslens').start()<cr>]] },
      { "#", [[#<cmd>lua require('hlslens').start()<cr>]] },
      { "g*", [[g*<cmd>lua require('hlslens').start()<cr>]] },
      { "g#", [[g#<cmd>lua require('hlslens').start()<cr>]] },
      -- FIXME: if hls started, <esc> should stop hls first, need a map which auto changes it self
    },
    opts = { calm_down = true, nearest_only = true },
  },
}

local m = vim.keymap.set
m("!", "<c-f>", "<right>")
m("!", "<c-b>", "<left>")
m("!", "<c-p>", "<up>")
m("!", "<c-n>", "<down>")
m("!", "<c-a>", "<home>")
m("!", "<c-e>", "<end>")
m("n", "gl", "gx", { remap = true })
m("n", "<esc>", "<Plug>(KsbCloseOrQuitAll)")
-- avoid going back to term mode(paste_window)
m("n", "i", "<Plug>(KsbCloseOrQuitAll)")
