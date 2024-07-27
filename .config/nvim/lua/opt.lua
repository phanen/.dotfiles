-- options flavour
-- * xx-expr
-- * xx-func
-- * xx-prg

local o, g = vim.o, vim.g

-- vim.opt.shm = 'I'

-- TODO: opt_global opt_local wo go bo o opt
-- don't use ftplugin style
g.markdown_recommended_style = 0

g.no_man_maps = 0

-- stylua: ignore start
-- o.fileencodings  = "ucs-bom,utf-8,utf-16,gbk,big5,gb18030,latin1"
-- o.fileencodings  = "ucs-bom,utf-8,utf-16,gbk,big5,gb18030,latin1"
-- o.laststatus = 1

-- good indent
o.expandtab      = true -- use space (`:retab!` to swap space and tabs)
o.shiftwidth     = 0    -- (auto)indent's width (follow `ts`)
o.softtabstop    = 0    -- inserted tab's width (follow `sw`)
o.tabstop        = 2    -- tab's (shown) width, also for spaces count in `:retab`

-- good looking
o.number = true
o.relativenumber = true

-- good operation
o.jumpoptions = 'stack,unload'
o.matchpairs = '(:),{:},[:],<:>'
-- PERF: a height based one
-- PERF: possible to optionaly scroll (e.g. mouse point)
-- o.scrolloff = 16
o.scrolloff = 20
o.showbreak = '↪ '
o.splitright = true
-- TODO: $$?
o.virtualedit = 'block'
o.whichwrap = 'b,s,h,l'

-- good search
o.ignorecase = true
o.smartcase = true

-- o.termguicolors  = true

-- persistant
o.undofile = true
-- o.swapfile       = true

o.cursorlineopt = 'number'
o.cursorline = true
o.colorcolumn = '+1'

o.signcolumn = 'yes:1'

-- if wrap
-- o.wrap           = false
-- o.linebreak      = true
-- o.breakindent    = true
-- o.sidescrolloff  = 8
-- o.sidescroll     = 0
-- o.smoothscroll   = true

-- (not sure) for gui, maybe we need fallback to xsel/xclip/wl-copy
o.clipboard = 'unnamedplus'
-- TODO: paste from external
-- FIXME: osc paste error on this function

if env.SSH_TTY then
  vim.g.clipboard = {
    copy = {
      ['+'] = function(lines)
        local content = table.concat(lines, '\n')
        local encoded = vim.base64.encode(content)
        api.nvim_chan_send(2, string.format('\027]52;c;%s\027\\', encoded))
      end,
    },
    paste = {
      ['+'] = function() require('vim.ui.clipboard.osc52').paste('+')() end,
    },
  }
end

-- -- https://github.com/neovim/neovim/pull/20750
-- -- https://github.com/neovim/neovim/pull/27217
-- o.foldlevelstart = 99
-- o.foldtext       = ''
-- o.foldmethod     = "expr"
-- o.foldexpr       = 'nvim_treesitter#foldexpr()'
-- enable this, don't need a auto-save... but dangerous
-- o.autowriteall   = true

-- unknow
-- o.lazyredraw = false

-- useless
-- o.ruler = false
-- o.showmode = false

o.helpheight = 10


o.mouse = 'a'
o.mousemoveevent = true

-- cmp
o.pumheight = 14
-- o.completeopt    = 'menuone'

-- stylua: ignore end
-- loading shada is slow, so we're going to load it manually,
-- after UI-enter so it doesn't block startup.
if g.lazy_shada then
  local shada = o.shada
  o.shada = ''
  au('User', {
    group = ag('LazyShada', { clear = true }),
    pattern = 'VeryLazy',
    callback = function()
      o.shada = shada
      pcall(vim.cmd.rshada, { bang = true })
    end,
  })
end

local opt_tbl2str = function(opts) return vim.iter(opts):join(',') end
vim.o.viewoptions = 'folds,curdir'

vim.o.completeopt = 'menu,menuone,noselect'

-- vim.o.confirm = true

vim.o.diffopt = opt_tbl2str {
  'internal',
  'filler',
  'closeoff',
  'hiddenoff', -- Do not use diff mode for a buffer when it becomes hidden.
  'algorithm:minimal',
  -- "linematch:60", -- https://github.com/neovim/neovim/pull/14537
}

if vim.fn.executable('rg') == 1 then
  -- ignore
  vim.o.grepprg = 'rg --vimgrep -.'
  -- vim.o.grepformat = '%f:%l:%c:%m'
end
