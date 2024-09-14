local o, aug, com = vim.o, u.aug, u.com

o.nu = true
o.rnu = true
o.ignorecase = true
o.smartcase = true
o.undofile = true
o.swapfile = false
o.clipboard = 'unnamedplus' -- builtin fallback mechanism
o.jumpoptions = 'clean,stack' -- https://github.com/neovim/neovim/pull/29347
o.matchpairs = '(:),{:},[:],<:>'
o.scrolloff = 20
o.showbreak = '↪ '
o.splitright = true
o.helpheight = 10
o.virtualedit = 'block' -- `$$` to expand
o.whichwrap = 'b,s,h,l'
o.mouse = 'a'
o.mousemoveevent = true
o.updatetime = 500 -- CursorHold
o.winblend = 20 -- float win transparency
o.pumblend = 20 -- cmp menu transparency
o.pumheight = 10
o.omnifunc = 'v:lua.vim.lsp.omnifunc' -- set before lsp attach
o.keywordprg = ':KeywordPrg'
o.diffopt = 'internal,filler,closeoff,hiddenoff,algorithm:minimal' -- https://github.com/neovim/neovim/pull/14537

-- column/line
o.signcolumn = 'yes:1' -- avoid signcolumn flick
o.colorcolumn = '+1' -- highlight 'textwidth'
o.cursorlineopt = 'number'
o.cursorline = true
o.showtabline = 2 -- always show tab title
o.laststatus = 3 -- one statusline for all windows
o.statusline =
  "%F [%{get(b:,'gitsigns_head','')}] %l:%c/%L%= [%{&fileencoding?&fileencoding:&encoding}] "

-- indentline '|'
o.expandtab = true -- use space (`:retab!` to swap space and tabs)
o.shiftwidth = 0 -- (auto)indent's width (follow `ts`)
o.softtabstop = 0 -- inserted tab's width (follow `sw`)
o.tabstop = 2 -- tab's (shown) width, also for spaces count in `:retab`
o.list = true
o.listchars = 'trail:•,nbsp:.,precedes:❮,extends:❯,tab:› ,leadmultispace:'
  .. g.indentsym
  .. '  '
aug.indentline = {
  'OptionSet',
  {
    pattern = { 'shiftwidth', 'expandtab', 'tabstop' },
    callback = function() u.misc.update_idl(vim.v.option_type == 'local') end,
  },
  'BufEnter',
  function() u.misc.update_idl(true) end,
}

com.AppendModeline = function() return u.misc.append_modeline() end
com.EditFtplugin =
  { function(_) return u.misc.edit_ftplugin(_.fargs[1]) end, nargs = '*', complete = 'filetype' }
com.Ghist = [[G log -p --follow -- %]]
com.KeywordPrg = { function(_) return u.misc.keywordprg(_) end, nargs = '*' }
com.R = { function(_) u.msg.pipe_cmd(_.args) end, nargs = '*', complete = 'command' }
com.ToggleDiagnostic = function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end
com.ToggleInlay = function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end
com.UpdateChore = function() u.script.update_chore() end
com.UpdateMeta = function() u.script.update_meta() end
com.UpdateSpec = function() u.script.update_spec() end
com.W = [[execute 'w !sudo tee % > /dev/null' <bar> edit!]]

aug.bigfile = { 'BufReadPre', function(_) u.misc.bigfile_preset(_) end }
aug.lastpos = { 'BufReadPost', [[sil! norm! g`"zv']] }
aug.lsp = { 'LspAttach', function(_) return u.misc.lsp_attach(_) end }
aug.reflow = { 'VimResized', [[if &co<100 | winc\| | else | winc= |endif]] }
aug.bdelete = { 'BufDelete', function(_) return u.misc.record_bdelete(_) end }
aug.yankhl = { 'TextYankPost', function() vim.highlight.on_yank { timeout = 100 } end } -- no TextYankPre, then always map d -> "_d
aug.autowrite = -- auto reload buffer on external write
  { { 'FocusGained', 'BufEnter', 'CursorHold' }, [[if getcmdwintype() == ''| checkt | endif]] }
aug.lz_load = {
  'ModeChanged',
  { once = true, pattern = '*:[ictRss\x13]*', callback = function() return u.im.setup() end },
  'DirchangedPre',
  { once = true, callback = function() return u.dirstack.setup() end },
}
