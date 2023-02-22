
-- overwrite "=
vim.o.clipboard = "unnamedplus"
vim.o.mouse = 'a'
vim.o.undofile = true

vim.o.number = true
vim.o.relativenumber = true

-- awesome utf-8
vim.scriptencoding = 'utf-8'
vim.o.encoding = 'utf-8'
vim.o.fileencoding = 'utf-8'
vim.o.termencoding = 'utf-8'

-- case insensitive
-- UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = false

-- 1 tab = 2 space
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2


vim.o.expandtab = true
vim.o.autoindent = true
vim.o.breakindent = true

vim.o.scrolloff = 8


-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Set colorscheme
vim.o.termguicolors = true
-- vim.cmd [[colorscheme onedark]]
vim.cmd [[colorscheme tokyonight]]

-- Set completeo to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- vim.api.nvim_set_hl(1, "Normal", {bg = "none"})
-- vim.api.nvim_set_hl(1, "NormalFloat", {bg = "none"})
