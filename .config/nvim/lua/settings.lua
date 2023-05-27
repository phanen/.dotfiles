local o, wo = vim.o, vim.wo

o.clipboard = "unnamed"
o.mouse = 'a'
o.undofile = true

o.number = true
o.relativenumber = true

-- https://stackoverflow.com/questions/2574027/automatically-go-to-next-line-in-vim--TODO
vim.cmd [[set whichwrap+=h,l]]

-- o.list = true
-- o.listchars = (o.listchars .. 'eol:↳')

-- case insensitive
-- UNLESS /C or capital in search
o.ignorecase = true
o.smartcase = true
o.hlsearch = false

-- 1 tab = 2 space
o.tabstop = 4
o.softtabstop = 2
o.shiftwidth = 2

o.expandtab = true
o.autoindent = true
o.breakindent = true

o.scrolloff = 16

-- Decrease update time
o.updatetime = 250
vim.wo.signcolumn = 'yes'

o.termguicolors = true

-- Set completeo to have a better completion experience
-- TODO
-- o.completeopt = 'menuone,noselect,noinsert'

-- vim.api.nvim_set_hl(1, "Normal", {bg = "none"})
-- vim.api.nvim_set_hl(1, "NormalFloat", {bg = "none"})

-- dump result of Ex
vim.cmd [[
function! s:Capture(bang, cmd)
  let message = execute(a:cmd)

  if a:bang
    new
    setlocal buftype=nofile bufhidden=hide noswapfile
  endif

  call append('.', split(message, '\r\?\n'))
  redraw!
endfunction
command! -bang -nargs=+ -complete=command Capture call <SID>Capture("<bang>" == '!', <q-args>)

]]
vim.cmd[[
function! Redir(cmd, rng, start, end)
	for win in range(1, winnr('$'))
		if getwinvar(win, 'scratch')
			execute win . 'windo close'
		endif
	endfor
	if a:cmd =~ '^!'
		let cmd = a:cmd =~' %'
			\ ? matchstr(substitute(a:cmd, ' %', ' ' . shellescape(escape(expand('%:p'), '\')), ''), '^!\zs.*')
			\ : matchstr(a:cmd, '^!\zs.*')
		if a:rng == 0
			let output = systemlist(cmd)
		else
			let joined_lines = join(getline(a:start, a:end), '\n')
			let cleaned_lines = substitute(shellescape(joined_lines), "'\\\\''", "\\\\'", 'g')
			let output = systemlist(cmd . " <<< $" . cleaned_lines)
		endif
	else
		redir => output
		execute a:cmd
		redir END
		let output = split(output, "\n")
	endif
	vnew
	let w:scratch = 1
	setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
	call setline(1, output)
endfunction

" This command definition includes -bar, so that it is possible to "chain" Vim commands.
" Side effect: double quotes can't be used in external commands
command! -nargs=1 -complete=command -bar -range Redir silent call Redir(<q-args>, <range>, <line1>, <line2>)

" This command definition doesn't include -bar, so that it is possible to use double quotes in external commands.
" Side effect: Vim commands can't be "chained".
command! -nargs=1 -complete=command -range Redir silent call Redir(<q-args>, <range>, <line1>, <line2>)
]]

--Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force to select one from the menu
-- shortness: avoid showing extra messages when using completion
-- updatetime: set updatetime for CursorHold
vim.opt.completeopt = {'menuone', 'noselect', 'noinsert'}
vim.opt.shortmess = vim.opt.shortmess + { c = true}
vim.api.nvim_set_option('updatetime', 300)

-- Fixed column for diagnostics to appear
-- Show autodiagnostic popup on cursor hover_range
-- Goto previous / next diagnostic warning / error
-- Show inlay_hints more frequently

vim.cmd [[
  set signcolumn=yes
  autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]]
