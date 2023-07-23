local o, wo = vim.o, vim.wo

o.clipboard = "unnamedplus"
o.mouse = 'a'
o.undofile = true

o.number = true
o.relativenumber = true

-- https://stackoverflow.com/questions/2574027/automatically-go-to-next-line-in-vim--TODO
-- vim.cmd [[set whichwrap+=h,l]]
o.whichwrap = o.whichwrap .. ",h,l"

-- o.list = true
-- o.listchars = (o.listchars .. 'eol:↳')

-- case insensitive
-- UNLESS /C or capital in search
o.ignorecase = true
o.smartcase = true
o.hlsearch = false

-- 1 tab = 2 space
o.tabstop = 4
o.softtabstop = 2
o.shiftwidth = 2

o.expandtab = true
o.autoindent = true
o.breakindent = true

o.scrolloff = 16

wo.signcolumn = 'yes'
wo.conceallevel = 2

o.termguicolors = true

--Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force to select one from the menu
-- shortness: avoid showing extra messages when using completion
-- updatetime: set updatetime for CursorHold
vim.opt.completeopt = { 'menuone', 'noselect', 'noinsert' }
vim.opt.shortmess = vim.opt.shortmess + { c = true }
vim.api.nvim_set_option('updatetime', 300)

-- Fixed column for diagnostics to appear
-- Show autodiagnostic popup on cursor hover_range
-- Goto previous / next diagnostic warning / error
-- Show inlay_hints more frequently

vim.cmd [[
  set signcolumn=yes
  autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]]

vim.opt.wildignore:append({ ".javac", "node_modules", "*.pyc" })
vim.opt.wildignore:append({ ".aux", ".out", ".toc" }) -- LaTeX
vim.opt.wildignore:append({ ".o", ".obj", ".dll", ".exe", ".so", ".a", ".lib", ".pyc", ".pyo", ".pyd", ".swp", ".swo",
	".class", ".DS_Store", ".git", ".hg", ".orig" })

-- avoid sticky escape as alt
o.ttimeout = false
o.ttimeoutlen = 10
