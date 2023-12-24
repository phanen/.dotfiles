function! QuickFixOpenAll()
  if empty(getqflist())
      return
  endif
  let s:prev_val = ""
  for d in getqflist()
    let s:curr_val = bufname(d.bufnr)
    if (s:curr_val != s:prev_val)
      exec "edit " . s:curr_val
    endif
    let s:prev_val = s:curr_val
  endfor
endfunction


" nnoremap <buffer> <silent> <leader>q <cmd>cclose<cr>
" nnoremap <buffer> <silent> <leader>qf <cmd>call QuickFixOpenAll<cr>
nnoremap <buffer> <silent> dd <cmd>call setqflist(filter(getqflist(), {idx -> idx != line('.') - 1}), 'r') <bar> cc<cr>
