nnoremap <buffer> <silent> dd <cmd>call setqflist(filter(getqflist(), {idx -> idx != line('.') - 1}), 'r') <bar> cc<cr>
