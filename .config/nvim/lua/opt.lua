local o, wo, opt = vim.o, vim.wo, vim.opt

o.clipboard = "unnamedplus"
o.mouse = "a"
o.undofile = true
o.number = true
o.relativenumber = true
o.termguicolors = true

-- https://www.zhihu.com/question/22363620
o.fileencodings = "ucs-bom,utf-8,utf-16,gbk,big5,gb18030,latin1"
o.whichwrap = "b,s,h,l"
o.ignorecase = true -- use /C
o.smartcase = true
-- o.hlsearch = false

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

-- message
opt.shortmess = opt.shortmess + { c = true }

o.updatetime = 1000 -- for CursorHold
-- o.timeout = false
o.timeoutlen = 100
o.ttimeout = false -- avoid sticky escape as alt

for _, provider in ipairs({ "perl", "node", "ruby", "python", "python3", }) do
  local var = "loaded_" .. provider .. "_provider"
  vim.g[var] = 0
end

-- vim:foldmethod=marker
