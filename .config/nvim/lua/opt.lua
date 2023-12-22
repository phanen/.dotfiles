local o, wo, opt = vim.o, vim.wo, vim.opt

-- basics {{{
o.clipboard = "unnamedplus"
o.mouse = "a"
o.undofile = true
o.number = true
o.relativenumber = true
o.termguicolors = true

-- https://www.zhihu.com/question/22363620
o.fileencodings = "ucs-bom,utf-8,utf-16,gbk,big5,gb18030,latin1"
o.whichwrap = "b,s,h,l"

-- unless /C or capital in search
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
o.shiftround = true

o.scrolloff = 16

wo.conceallevel = 2

opt.completeopt = { "menuone", "noselect", "noinsert" }

o.splitright = true

-- o.wrapmargin = 2
o.showbreak = "↪ "
o.list = true -- invisible chars
opt.listchars = {
  eol = nil,
  tab = "  ", -- Alternatives: '▷▷',
  extends = "…", -- Alternatives: … » ›
  precedes = "░", -- Alternatives: … « ‹
  trail = "•", -- BULLET (U+2022, UTF-8: E2 80 A2)
}
-- }}}

-- message
opt.shortmess = opt.shortmess + { c = true }

-- timings {{{
-- for CursorHold
o.updatetime = 300
o.ttimeout = false -- avoid sticky escape as alt
o.timeoutlen = 100 -- for which-key popup
-- }}}

-- vim:foldmethod=marker
