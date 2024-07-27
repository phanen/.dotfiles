if exists('g:vscode') | finish | endif

if exists("g:loaded_play_au") || &cp | finish | endif
let g:loaded_play_au = 1

aug lastplace
    au!
    " au BufReadPost   * call lastplace#jump()
    " au BufWinEnter * call lastplace#open_folds()
aug END
