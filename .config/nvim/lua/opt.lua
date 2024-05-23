local o, g = vim.o, vim.g

-- don't use ftplugin style
g.markdown_recommended_style = 0

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
o.virtualedit    = 'block' -- contain the longest line

o.ignorecase     = true
o.smartcase      = true

-- (not sure) for gui, maybe we need fallback to xsel/xclip/wl-copy
o.clipboard = 'unnamedplus'
-- TODO: paste from extenal
-- FIXME: osc paste error on this function

if vim.env.SSH_TTY then
  vim.g.clipboard = {
    copy = {
      ['+'] = function(lines)
        local content = table.concat(lines, '\n')
        local encoded = vim.base64.encode(content)
        vim.api.nvim_chan_send(2, string.format('\027]52;c;%s\027\\', encoded))
      end,
    },
    paste = {
      ['+'] = function() require('vim.ui.clipboard.osc52').paste('+')() end,
    },
  }
end

o.foldexpr       = 'nvim_treesitter#foldexpr()'
-- o.autowriteall   = true
