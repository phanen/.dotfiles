local o, aug, com = vim.o, u.aug, u.com

o.nu = true
o.rnu = true
o.ignorecase = true
o.smartcase = true
o.undofile = true
o.swapfile = false
o.clipboard = 'unnamedplus' -- builtin fallback mechanism
o.matchpairs = '(:),{:},[:],<:>'
o.jumpoptions = 'clean,stack' -- https://github.com/neovim/neovim/pull/29347
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
o.exrc = true
-- o.lazyredraw = true
-- o.showcmd = false

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
o.tabstop = 2 -- tab's (shown) width, also for spaces count in `:retab`
o.shiftwidth = 0 -- (auto)indent's width (follow `ts`)
o.softtabstop = 0 -- inserted tab's width (follow `sw`)
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
com.ToggleDiag = function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end
com.ToggleInlay = function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end
com.UpdateChore = function() u.script.update_chore(true) end
com.Gitignore = function() u.pick.gitignore() end
com.License = function() u.pick.license() end
com.Nvim = function() return u.pick.nvim() end
com.Plugin = function() return u.pick.lazy() end
com.Rtp = function() return u.pick.rtp() end
com.Todo = function() return u.pick.todos() end
com.Scriptname = function() return u.pick.scriptnames() end
com.Localrc = [[exe('edit' . g:local_path)]]
com.Trim = [[%s/\s*$//g | norm! ``]]
com.W = [[execute 'w !sudo tee % > /dev/null' <bar> edit!]]
com.DiagQf = [[lua vim.diagnostic.setqflist()]]
com.DiagLl = [[lua vim.diagnostic.setloclist()]]
com.DiagFloat = [[lua vim.diagnostic.open_float()]]
com.DirHist = function() u.dirstack.hist() end
com.Hypen2Star = [[%s/^\([  ]*\)- \(.*\)/\1* \2/g]]
com.Four2Two = [[%s;^\(\s\+\);\=repeat(' ', submatch(0)->len()/2);g]]
com.YF = [[let @+= '%:p'->expand()]]

aug.bigfile = { 'BufReadPre', function(_) u.misc.bigfile_preset(_) end }
aug.lastpos = { 'BufReadPost', [[sil! norm! g`"zv']] }
aug.reflow = { 'VimResized', [[if winnr()>1 | if &co<100 | winc\| | else | winc= | endif | endif]] }
aug.bdelete = { 'BufDelete', function(_) u.misc.record_bdelete(_) end }
aug.yankhl = { 'TextYankPost', function() vim.hl.on_yank { timeout = 100 } end }
aug.autowrite = -- auto reload buffer on external write
  { { 'FocusGained', 'BufEnter', 'CursorHold' }, [[if getcmdwintype()=='' | checkt | endif]] }
aug.autosave = {
  { 'BufLeave', 'WinLeave', 'FocusLost', 'InsertLeave', 'TextChanged' },
  [[if &bt=='' && bufname()!='' | update! | endif]],
}

aug.lz_load = {
  'ModeChanged',
  { once = true, pattern = '*:[ictRss\x13]*', callback = function() u.im.setup() end },
  'DirchangedPre',
  { once = true, callback = function() u.dirstack.setup() end },
  'FileType',
  { once = true, callback = function() u.lsp.setup() end },
  'LspAttach',
  { callback = function(_) u.lsp.on(_) end },
  'FileType',
  { callback = function() pcall(vim.treesitter.start) end },
}

-- vim.treesitter.language.register('json', { 'jsonc' })
