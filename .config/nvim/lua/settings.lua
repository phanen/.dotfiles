
-- overwrite "=
vim.o.clipboard = "unnamedplus"
vim.o.mouse = 'a'
vim.o.undofile = true

vim.o.number = true
vim.o.relativenumber = true

-- awesome utf-8
vim.scriptencoding = 'utf-8'
vim.o.encoding = 'utf-8'
vim.o.fileencoding = 'utf-8'
vim.o.termencoding = 'utf-8'

-- case insensitive
-- UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = false

-- 1 tab = 2 space
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2


vim.o.expandtab = true
vim.o.autoindent = true
vim.o.breakindent = true

vim.o.scrolloff = 8


-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Set colorscheme
vim.o.termguicolors = true
-- vim.cmd [[colorscheme onedark]]
vim.cmd [[colorscheme tokyonight]]

-- Set completeo to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

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
