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

vim.cmd[[
	function! Textobj_url() abort
	  if match(&runtimepath, 'vim-highlighturl') != -1
		" Note that we use https://github.com/itchyny/vim-highlighturl to get the URL pattern.
		let url_pattern = highlighturl#default_pattern()
	  else
		let url_pattern = expand('<cfile>')
		" Since expand('<cfile>') also works for normal words, we need to check if
		" this is really URL using heuristics, e.g., URL length.
		if len(url_pattern) <= 10
		  return
		endif
	  endif

	  " We need to find all possible URL on this line and their start, end index.
	  " Then find where current cursor is, and decide if cursor is on one of the
	  " URLs.
	  let line_text = getline('.')
	  let url_infos = []

	  let [_url, _idx_start, _idx_end] = matchstrpos(line_text, url_pattern)
	  while _url !=# ''
		let url_infos += \[\[_url, _idx_start+1, _idx_end\]\]
		let [_url, _idx_start, _idx_end] = matchstrpos(line_text, url_pattern, _idx_end)
	  endwhile

	  " echo url_infos
	  " If no URL is found, do nothing.
	  if len(url_infos) == 0
		return
	  endif

	  let [start_col, end_col] = [-1, -1]
	  " If URL is found, find if cursor is on it.
	  let [buf_num, cur_row, cur_col] = getcurpos()[0:2]
	  for url_info in url_infos
		" echo url_info
		let [_url, _idx_start, _idx_end] = url_info
		if cur_col >= _idx_start && cur_col <= _idx_end
		  let start_col = _idx_start
		  let end_col = _idx_end
		  break
		endif
	  endfor

	  " Cursor is not on a URL, do nothing.
	  if start_col == -1
		return
	  endif

	  " Now set the '< and '> mark
	  call setpos("'<", [buf_num, cur_row, start_col, 0])
	  call setpos("'>", [buf_num, cur_row, end_col, 0])
	  normal! gv
	endfunction

	function! Textobj_buffer() abort
	  let buf_num = bufnr()

	  call setpos("'<", [buf_num, 1, 1, 0])
	  call setpos("'>", [buf_num, line('$'), 1, 0])
	  execute 'normal! `<V`>'
	endfunction
]]

-- url
map({ "x", "o" }, "iu", "<cmd>call Textobj_url()<cr>", { desc = "URL text object" })
-- entire buffer
-- FIXME: visual mode
map({ "x", "o" }, "ig", "<cmd>call Textobj_buffer()<cr><c-o>", { desc = "buffer text object" })
