" function! IcecreamInitialize()
" python << EOF
" class StrawberryIcecream:
"   def __call__(self):
"     print('EAT ME')
"     print('EAT ME')
"     print('EAT ME')
" EOF
" endfunction
"
" call IcecreamInitialize()
" python <<EOF
" StrawberryIcecream()()
" EOF

aug play
  au!
  " au ModeChanged * echo getpos("'<")
  au ModeChanged * call writefile(getpos("'<"), "/home/phanium/b/neovim/event.log", "a")
  " au ModeChanged * silent! echo getpos("'<")
  "au ModeChanged * echo getpos("'>")
aug END


function s:Jump(dir, map)
    let [list, pos] = getjumplist()
    if a:dir < 0
        let list = reverse(list)
        let pos = len(list) - 1 - pos
    endif
    let list = map(list, a:map)
    let cnt = index(list, 1, max([pos, 0])) - pos
    if cnt > 0
        execute "normal! ".cnt.(a:dir > 0 ? "\<C-I>" : "\<C-O>")
    endif
endfunction

" https://github.com/tpope/vim-fugitive/issues/1312#issuecomment-523689284
function s:JumpOtherBuffer(dir)
    call s:Jump(a:dir, 'v:val.bufnr != '.bufnr('%'))
endfunction
nnoremap <silent> [j :call <SID>JumpOtherBuffer(-1)<CR>
nnoremap <silent> ]j :call <SID>JumpOtherBuffer(1)<CR>

function s:JumpOtherListedBuffer(dir)
    call s:Jump(a:dir, 'v:val.bufnr != '.bufnr('%').' && get(get(getbufinfo(v:val.bufnr), 0, {}), "listed")')
endfunction
nnoremap <silent> [J :call <SID>JumpOtherListedBuffer(-1)<CR>
nnoremap <silent> ]J :call <SID>JumpOtherListedBuffer(1)<CR>
