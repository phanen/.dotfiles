-- options flavour
-- * xx-expr
-- * xx-func
-- * xx-prg
-- opt_global opt_local wo go bo wo o opt

local o = vim.o
local go = vim.go

-- o.fileencodings  = "ucs-bom,utf-8,utf-16,gbk,big5,gb18030,latin1"
require('opt.common')
require('opt.clipboard')

-- TODO: colored above/below
o.cursorlineopt = 'number'
o.cursorline = true

-- loading shada is slow, so we're going to load it manually,
-- after UI-enter so it doesn't block startup.
if g.lazy_shada then
  local shada = o.shada
  o.shada = ''
  autocmd('User', {
    group = ag('LazyShada', { clear = true }),
    pattern = 'VeryLazy',
    callback = function()
      o.shada = shada
      pcall(vim.cmd.rshada, { bang = true })
    end,
  })
end

if fn.executable('rg') == 1 then
  o.grepprg = 'rg --vimgrep -.' -- ignore
end

-- o.laststatus = 0
-- o.cmdheight = 0

-- go.statusline = [[%{mode()} %{mode()}]]
-- go.statusline = [[%!v:lua.require('mod.stl').get()]]

-- https://github.com/neovim/neovim/pull/20750
-- https://github.com/neovim/neovim/pull/27217
-- o.foldlevelstart = 99
-- o.foldtext = ''
-- o.foldmethod = 'expr'
-- o.foldexpr = 'nvim_treesitter#foldexpr()'
