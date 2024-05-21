local o, g = vim.opt, vim.g

-- don't use ftplugin style
g.markdown_recommended_style = 0

-- default enabeld in neovim
-- o.hidden         = true
-- stylua: ignore start
-- o.fileencodings  = "ucs-bom,utf-8,utf-16,gbk,big5,gb18030,latin1"
-- o.laststatus = 1

-- TODO: compile it to vimscript
g.mapleader      = ' '
g.maplocalleader = '+'

o.number         = true
o.relativenumber = true

o.jumpoptions    = 'stack'
o.matchpairs     = '(:),{:},[:],<:>'
o.scrolloff      = 16
o.showbreak      = '↪ '
o.splitright     = true
o.termguicolors  = true
o.undofile       = true
o.whichwrap      = 'b,s,h,l'

o.ignorecase     = true
o.smartcase      = true

o.expandtab      = true -- use space (`:retab!` to swap space and tabs)
o.shiftwidth     = 0    -- (auto)indent's width (follow `ts`)
o.softtabstop    = 0    -- inserted tab's width (follow `sw`)
o.tabstop        = 2    -- tab's (shown) width, also for spaces count in `:retab`

-- (not sure) for gui, maybe we need fallback to xsel/xclip/wl-copy
o.clipboard = 'unnamedplus'
-- TODO: paste from extenal
-- FIXME: osc paste error on this function
if vim.env.SSH_TTY then
  vim.g.clipboard = {
    copy = { ['+'] = function(lines) require('vim.ui.clipboard.osc52').copy('+')(lines) end },
    paste = { ['+'] = function() require('vim.ui.clipboard.osc52').paste('+')() end },
    -- paste = { ['+'] = function(...) end, }, -- make it reconized
  }
end


o.foldexpr       = 'nvim_treesitter#foldexpr()'
-- o.autowriteall   = true
