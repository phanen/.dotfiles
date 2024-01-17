---@diagnostic disable: undefined-global
vim.loader.enable()

vim.g.mapleader = " "
vim.o.clipboard = "unnamedplus"
vim.o.laststatus = 0
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

local m = vim.keymap.set
local root = vim.fn.stdpath "data" .. "/lazy"
local plug = function(basename)
  vim.opt.rtp:prepend(root .. "/" .. basename)
  local packname = vim.fn.trim(basename, ".nvim")
  return function(opts) require(packname).setup(opts) end
end

-- TODO: avoid screen blink (or avoid redraw??)
-- TODO: hot update to neovim...
plug "kitty-scrollback.nvim" {
  custom = function(_)
    return {
      -- keymaps_enabled = false,
      paste_window = { yank_register_enabled = false },
      restore_options = true,
      highlight_overrides = { KittyScrollbackNvimVisual = { bg = "Cyan", fg = "Black" } },
    }
  end,
  last_cmd_output = function()
    return {
      paste_window = { yank_register_enabled = false },
      restore_options = true,
      highlight_overrides = { KittyScrollbackNvimVisual = { bg = "Cyan", fg = "Black" } },
      kitty_get_text = { extent = "last_cmd_output", ansi = true },
    }
  end,
}

plug "flash.nvim" { modes = { search = { enabled = false } } }
m({ "n", "x", "o" }, "s", function() require("flash").jump() end)
m({ "n", "x", "o" }, "_", function() require("flash").jump() end)

m("!", "<c-f>", "<right>")
m("!", "<c-b>", "<left>")
m("!", "<c-p>", "<up>")
m("!", "<c-n>", "<down>")
m("!", "<c-a>", "<home>")
m("!", "<c-e>", "<end>")

-- avoid going back to term mode(paste_window)
m("n", "i", "<Plug>(KsbCloseOrQuitAll)")
m("n", "q", "<Plug>(KsbCloseOrQuitAll)")
m("n", "a", "<Plug>(KsbCloseOrQuitAll)")
m("n", "<c-c>", "y")
m("n", "u", "<c-u>")
m("n", "d", "<c-d>")
m({ "n", "o", "x" }, "ga", "G")
-- fake a shell integration
m(
  "n",
  "<leader><leader>",
  function() return "/" .. vim.fn.getenv "USER" .. "@" .. vim.fn.system { "hostnamectl", "hostname" } end,
  { expr = true }
)
