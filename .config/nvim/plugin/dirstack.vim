let g:dir_stack = []
command -complete=dir -nargs=1 -bang -bar Pushd
      \ call add(g:dir_stack, getcwd()) | execute 'cd<bang>' <q-args>
command -bang -bar Popd
      \ let dir = remove(g:dir_stack, -1) | execute 'cd<bang>' dir | unlet dir
command -bar Dirs echo g:dir_stack

nnoremap <leader>cd <cmd>Pushd %:h<cr>
nnoremap <leader>cb <cmd>Popd<cr>
