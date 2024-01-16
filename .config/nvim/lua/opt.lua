local o = vim.o

o.clipboard = "unnamedplus"
o.undofile = true
o.number = true
o.relativenumber = true
o.termguicolors = true
o.fileencodings = "ucs-bom,utf-8,utf-16,gbk,big5,gb18030,latin1"
o.whichwrap = "b,s,h,l"
o.jumpoptions = "stack"
o.scrolloff = 16
o.splitright = true
-- o.completeopt = "menuone,noselect,noinsert"

o.list = true
o.listchars = o.listchars .. ",leadmultispace:│ "
o.showbreak = "↪ "

o.ignorecase = true
o.smartcase = true

o.expandtab = true -- tab to space
o.tabstop = 2 -- width of actual <tab>
o.softtabstop = 2 -- width of inserted <tab>
o.shiftwidth = 2 -- width of indent-op

o.updatetime = 1000 -- for CursorHold
o.timeoutlen = 100
-- o.ttimeout = false -- avoid sticky escape as alt
o.ttimeoutlen = 0
o.synmaxcol = 200
