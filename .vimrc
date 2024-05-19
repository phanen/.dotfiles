" https://github.com/skwp/dotfiles/blob/master/vimrc
let mapleader=' '
set number relativenumber
set fileencodings=utf8,ucs-bom,gbk,cp936,gb2312,gb18030
set mouse=a
set clipboard=unnamed,unnamedplus
set term=xterm-256color
set hidden
set wrap
set autoread                                     " reload on external file changes
set backspace=indent,eol,start                   " backspace behaviour
set wildmenu wildmode=longest:full,full          " wildmode settings
filetype plugin indent on                        " enable filetype detection
set listchars=eol:¶,trail:•,tab:▸\               " whitespace characters
set scrolloff=16                                 " center cursor position vertically
set showmatch                                    " show matching brackets
syntax on
set autoindent expandtab                         " autoindentation & tabbing
set shiftwidth=2 softtabstop=2 tabstop=2         " 1 tab = 2 spaces
set hlsearch ignorecase incsearch smartcase      " search options
set nobackup noswapfile nowritebackup            " disable backup/swap files
set undofile undodir=~/.vim/undo undolevels=9999 " undo options
set lazyredraw                                   " enable lazyredraw
set nocursorline                                 " disable cursorline
set ttyfast                                      " enable fast terminal connection
set jumpoptions=stack
cnoreabbrev w!! w !sudo tee > /dev/null %|       " write file with sudo


"" cursor shape
"let &t_SI = "\e[6 q"
"let &t_EI = "\e[2 q"
"
"" reset the cursor on start (for older versions of vim, usually not required)
"augroup myCmds
"au!
"autocmd VimEnter * silent !echo -ne "\e[2 q"
"augroup END
"
"cnoremap <c-p> <up>
"cnoremap <c-n> <down>

"https://gist.github.com/xiyaowong/7e8fa86ecef639ae6f23aca3862e211e
nnoremap j gj
nnoremap gj j
nnoremap k gk
nnoremap gk k

inoremap <c-e> <end>

" Indent/Dedent
xnoremap < <gv
xnoremap > >gv

" windows
nnoremap <C-h> <C-w><C-h>
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>
xnoremap <C-h> <C-w><C-h>
xnoremap <C-j> <C-w><C-j>
xnoremap <C-k> <C-w><C-k>
xnoremap <C-l> <C-w><C-l>

if exists('g:ideavim')
sethandler <C-a> i-x-v:ide
sethandler <C-z> i-x-v:ide
sethandler <C-x> i-x-v:ide
sethandler <C-c> i-x-v:ide
sethandler <C-v> i-x-v:ide
sethandler <C-f> i-x-v:ide
sethandler <A-p> a:vim
sethandler <A-q> a:vim
sethandler <A-e> a:vim
sethandler <A-d> a:vim
sethandler <A-m> a:vim
sethandler <A-t> a:vim
sethandler <A-f> a:vim
sethandler <A-i> a:vim
sethandler <A-u> a:vim

" Should also set these keymaps in ide {{{
map <A-p> <Action>(GotoAction)
map <A-q> <Action>(HideAllWindows)
map <A-e> <Action>(ActivateProjectToolWindow)
map <A-d> <Action>(ActivateDebugToolWindow)
map <A-m> <Action>(ActivateProblemsViewToolWindow)
map <A-t> <Action>(ActivateTerminalToolWindow)
map <A-f> <Action>(FindInPath)
map <A-i> <Action>(CodeCompletion)
map <A-u> <Action>(ParameterInfo)
" Won't work in insert mode without these.
imap <A-p> <Action>(GotoAction)
imap <A-q> <Action>(HideAllWindows)
imap <A-e> <Action>(ActivateProjectToolWindow)
imap <A-d> <Action>(ActivateDebugToolWindow)
imap <A-m> <Action>(ActivateProblemsViewToolWindow)
imap <A-t> <Action>(ActivateTerminalToolWindow)
imap <A-f> <Action>(FindInPath)
imap <A-i> <Action>(CodeCompletion)
imap <A-u> <Action>(ParameterInfo)
" }}}

""" Plugins
set surround
set multiple-cursors
set commentary
" set argtextobj
set easymotion
set highlightedyank
" set textobj-entire
" set ReplaceWithRegister
set ideajoin
set NERDTree

nmap <leader>w <Plug>(easymotion-jumptoanywhere)
nmap <leader>l <Plug>(easymotion-lineanywhere)
nmap s <Plug>(easymotion-s)

" move lines up down
map <A-j> <Action>(MoveLineDown)
map <A-k> <Action>(MoveLineUp)

nnoremap [<space> O<Esc>0D
nnoremap ]<space> o<Esc>0D

imap <C-s> <Action>(SaveAll)
nmap <C-s> <Action>(SaveAll)
nmap <leader>s <Action>(SaveAll)

" buffers
nmap [b :bp<cr>
nmap ]b :bn<cr>

" navigation
nmap gd <Action>(GotoDeclaration)
nmap gy <Action>(GotoTypeDeclaration)
nmap gi <Action>(GotoImplementation)

nmap <C-p> <Action>(GotoFile)
xmap <C-p> <Action>(GotoFile)

nmap <leader>a <Action>(ShowIntentionActions)
xmap <leader>a <Action>(ShowIntentionActions)
nmap <leader>f <Action>(ReformatCode)
xmap <leader>f <Action>(ReformatCode)
nmap <leader>r <Action>(Refactorings.QuickListPopupAction)
xmap <leader>r <Action>(Refactorings.QuickListPopupAction)
nmap <leader>n <Action>(RenameElement)
xmap <leader>n <Action>(RenameElement)

finish
endif


" ---------
" - vsvim -
" ---------

"imap <C-s> :vsc File.SaveAll<cr>
"nmap <C-s> :vsc File.SaveAll<cr>
"nmap <leader>s :vsc File.SaveAll<cr>
"nmap <leader>f :vsc Edit.FormatDocument<cr>
"
"nmap [b :vsc Window.PreviousTab<CR>
"nmap ]b :vsc Window.NextTab<CR>
"
"nmap [g :vsc View.NextError<CR>
"nmap ]g :vsc View.PreviousError<CR>
"
"nmap <A-p> :vsc View.QuickActions<CR>
"imap <A-i> :vsc Edit.CompleteWord<CR>
"imap <A-u> :vsc Edit.ParameterInfo<CR>
"
"nmap <C-o> :vsc View.NavigateBackward<CR>
"nmap <C-t> :vsc View.NavigateForward<CR>
"
"nmap K :vsc Edit.QuickInfo<cr>
"nmap gd :vsc Edit.GoToDefinition<CR>
"nmap gi :vsc Edit.GoToImplementation<CR>
"nmap gr :vsc Edit.FindAllReferences<CR>
"
"nmap <leader>n :vsc Refactor.Rename<cr>
"xmap <leader>n :vsc Refactor.Rename<cr>
"
"nmap <leader>a :vsc View.QuickActionsForPosition<cr>
"xmap <leader>a :vsc View.QuickActionsForPosition<cr>
"
"nmap gc :vsc Edit.ToggleLineComment<CR>
"xmap gc :vsc Edit.ToggleLineComment<CR>
"
"nmap <space>fw :vsc Edit.GoToAll<CR>
