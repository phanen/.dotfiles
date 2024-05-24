" https://gist.github.com/xiyaowong/7e8fa86ecef639ae6f23aca3862e211e
" use `vim --version` to view features

let mapleader=' '

filetype plugin indent on
if &t_Co > 2 || has("gui_running")
  syntax on
  let c_comment_strings=1
endif

nn <c-s><c-d> <cmd>mksession! /tmp/reload-vim.vim <bar> cq!123<cr>
" TODO: autosave
nn <c-s><c-s> <cmd>q!<cr>
nn <leader>so <cmd>so<cr>
nn <leader><c-e> <cmd>e $MYVIMRC<cr>

" nvim default options {{{
se ai
se ar
"se bg="dark"
se bs=indent,eol,start
"se bdir=
se bo=all
se comments+=fb:•
se cms=
"se nocp
se cpt-="i"
se def= " handle by ftplugin
"se dir=
se dy=lastline " truncate ???
"se enc=utf-8
" se fcs=vert:│,fold:·,foldsep:│
se fcs=
se fo=tcqj
if executable('rg')
  se grepprg="rg --vimgrep -uu "
  se grepformat="%f:%l:%c:%m"
else
  se grepprg="grep -n -H -I $* /dev/null "
endif
se hid
se hi=10000
se hls
se inc=
se is
se isf-=: " ???
se nojs
se lnr
se nolrm
se ls=2
se lcs="tab:> ,trail:-,nbsp:+"
se mouse="nvi"
se mousem="popup_setpos"
se nf=bin,hex
se pa='.,,"
se ru
se ssop+=unix,slash ssop-=options " ???
se shm+=CF shm-=S
se sc
se ss=1 "?
se nosol
se swb=uselast " ??
se tpm=50
se tags=./tags;,tags " emacs_tags
se tgc
se ttimeout
se ttm=50
se tf
se viewoptions+=unix,slash viewoptions-=options
se vi+=!
se wmnu
se wop=pum,tagfile
" }}}

com DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis | wincmd p | diffthis

" options {{{
se nu rnu
se cb=unnamedplus
se term=xterm-256color
se mouse=a
se et sw=2 st=2 ts=2
se ic scs
se so=16
" se sm
" se nobackup noswapfile nowritebackup            " disable backup/swap files
se udf udir=~/.vim/undo ul=9999
se lz
se jop=stack

"se fencs=utf8,ucs-bom,gbk,cp936,gb2312,gb18030


let &t_SI .= "\e[=1c"
let &t_EI .= "\e[=2c"
" }}}

" autocmd {{{
    se fencs=utf8,ucs-bom,gbk,cp936,gb2312,gb18030
aug vimStartup
 au!
 au BufReadPost *
   \ let line = line("'\"")
   \ | if line >= 1 && line <= line("$") && &filetype !~# 'commit'
   \      && index(['xxd', 'gitrebase'], &filetype) == -1
   \ |   execute "normal! g`\""
   \ | endif
"au InsertEnter,InsertLeave * se cul!
aug END
" }}}

" keymap {{{
no! <c-a> <home>
no! <c-e> <end>
no! <c-f> <right>
no! <c-b> <left>
no! <c-p> <up>
no! <c-n> <down>
no! <c-o> <c-o>B
no! <c-j> <c-o>E<right>

map Q gq
sunm Q

nn j gj
nn gj j
nn k gk
nn gk k

xn <a-h> <gv
xn <a-l> >gv

nn <c-h> <c-w><c-h>
nn <c-j> <c-w><c-j>

nn d "kd
nn D "kD
nn c "kc
nn C "kC
nn <c-p> "kp

xn d "kd
xn D "kD
xn c "kc
xn C "kC
xn <c-p> "kp

ino <c-u> <c-g>u<c-u>
ino <c-w> <c-g>u<c-w>

nm <M-j> mz:m+<cr>`z
nm <M-k> mz:m-2<cr>`z
vm <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vm <M-k> :m'<-2<cr>`>my`<mzgv`yo`z
" }}}

" TODO: session seems buggy?
" vim:fdm=marker
