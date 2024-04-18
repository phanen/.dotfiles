local o, g = vim.opt, vim.g

g.mapleader = ' '
g.maplocalleader = '+'

-- o.laststatus = 1
-- stylua: ignore start
o.clipboard      = 'unnamedplus'
o.jumpoptions    = 'stack'
o.number         = true
o.relativenumber = true
o.scrolloff      = 16
o.showbreak      = '↪ '
o.splitright     = true
o.termguicolors  = true
o.undofile       = true
o.whichwrap      = 'b,s,h,l'
-- o.fileencodings  = "ucs-bom,utf-8,utf-16,gbk,big5,gb18030,latin1"

o.ignorecase     = true
o.smartcase      = true

o.expandtab      = true -- use space
o.tabstop        = 2 -- tab width
o.softtabstop    = 2 -- inserted tab
o.shiftwidth     = 2 -- indent

g.markdown_recommended_style = 0
