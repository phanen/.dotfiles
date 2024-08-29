local o = vim.o
local opt = vim.opt

o.nu = true
o.rnu = true

o.ignorecase = true
o.smartcase = true

o.undofile = true
o.swapfile = true

-- https://github.com/neovim/neovim/pull/29347
o.jumpoptions = 'stack,unload'

o.matchpairs = '(:),{:},[:],<:>'

o.scrolloff = 20

o.showbreak = '↪ '

o.splitright = true

o.helpheight = 10

-- `$$` to expand
o.virtualedit = 'block'

o.whichwrap = 'b,s,h,l'

o.mouse = 'a'
o.mousemoveevent = true

-- builtin cmp menu
o.pumheight = 10
-- o.completeopt = 'menu,menuone,noselect'

-- avoid signcolumn flick
o.signcolumn = 'yes:1'

-- highlight 'textwidth'
o.colorcolumn = '+1'
vim.cmd [[
hi ColorColumn ctermbg=lightgrey guibg=Error
]]

-- o.wrap          = false
if not o.wrap then
  o.linebreak = true
  o.breakindent = true
  o.sidescrolloff = 8
  o.sidescroll = 0
  o.smoothscroll = true
end

opt.diffopt = {
  'internal',
  'filler',
  'closeoff',
  'hiddenoff', -- Do not use diff mode for a buffer when it becomes hidden.
  'algorithm:minimal',
  -- "linematch:60", -- https://github.com/neovim/neovim/pull/14537
}

-- set it if default.lua fail to guess
-- o.termguicolors  = true

-- speedup macro (only for temporary usage)
-- o.lazyredraw = false

-- when we don't use auto-save
-- o.autowriteall   = true
