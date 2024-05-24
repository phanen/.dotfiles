if exists("g:loaded_lastplace_plugin") || &cp | finish | endif
let g:loaded_lastplace_plugin = 1

let s:lastplace_ignore_ft = ["gitrebase", "svn", "xxd"]
let s:lastplace_ignore_bt = ["help", "nofile", "quickfix"]
let s:lastplace_open_folds = 1

fu! s:skip()
    if index(s:lastplace_ignore_ft, &ft) != -1 | return 1 | endif

    if index(s:lastplace_ignore_bt, &bt) != -1 | return 1 | endif

    try
      if empty(glob(@%)) | return 1 | endif
    catch
        return 1
    endt

    " hgcommit, gitcommit
    if &ft !~# 'commit' | return 0 | endif
    return 1
endf

fu! lastplace#jump()
  if s:skip() | return | endif
  let l:line = line("'\"")
  let l:rem = line("$") - l:line

  " not need <c-e> for lastline, since already a large scrolloff is used here

  " fix E19: Mark has invalid line number
  " although `silent!` can also fix it (so why bother do it...)
  if l:line < 1 && l:rem < 0 | return | endif
  if l:rem >= 0 | normal! | g`"zv
  endif
endf

fu! lastplace#open_folds()
  if s:skip() | return | endif
  if foldclosed(".") != -1 && s:lastplace_open_folds
    normal! zvzz"
  endif
endf
