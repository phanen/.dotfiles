-- line object, https://vi.stackexchange.com/questions/24861/selector-for-line-of-text
vim.cmd [[
	function! Textobj_line(count) abort
	  normal! gv
	  if visualmode() !=# 'v'
		normal! v
	  endif
	  let startpos = getpos("'<")
	  let endpos = getpos("'>")
	  if startpos == endpos
		execute "normal! ^o".a:count."g_"
		return
	  endif
	  let curpos = getpos('.')
	  if curpos == endpos
		normal! g_
		let curpos = getpos('.')
		if curpos == endpos
		  execute "normal!" (a:count+1)."g_"
		elseif a:count > 1
		  execute "normal!" a:count."g_"
		endif
	  else
		normal! ^
		let curpos = getpos('.')
		if curpos == startpos
		  execute "normal!" a:count."-"
		elseif a:count > 1
		  execute "normal!" (a:count-1)."-"
		endif
	  endif
	endfunction
	xnoremap <silent> il :<C-U>call Textobj_line(v:count1)<CR>
	onoremap <silent> il :<C-U>execute "normal! ^v".v:count1."g_"<CR>
]]
