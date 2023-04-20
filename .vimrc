" basic
set number
set relativenumber
set encoding=utf8
set shortmess=atI

set mouse=a
set clipboard=unnamed,unnamedplus
set term=xterm-256color

set timeoutlen=50
set hidden

" layout
set wrap



set autoread                                     " reload on external file changes
set backspace=indent,eol,start                   " backspace behaviour
set wildmenu wildmode=longest:full,full          " wildmode settings

" ui
filetype plugin indent on                        " enable filetype detection
set listchars=eol:¶,trail:•,tab:▸\               " whitespace characters
" set scrolloff=999                                " center cursor position vertically
set showbreak=¬\                                 " Wrapping character
set showmatch                                    " show matching brackets
syntax on

" color
colorscheme koehler                                " set colorscheme
" hi Normal guibg=NONE ctermbg=NONE|               " transparency fix
" let g:onedark_termcolors=256                     " enable 256 colors support

" statusline
set laststatus=0                                 " disable statusline
set ruler rulerformat=%40(%=%<%F%m\ \
                      \›\ %{getfsize(@%)}B\ \
                      \›\ %l/%L:%v%)

" indent
set autoindent expandtab                         " autoindentation & tabbing
set shiftwidth=2 softtabstop=2 tabstop=2         " 1 tab = 2 spaces

" search
set hlsearch ignorecase incsearch smartcase      " search options

" undo
" set nobackup noswapfile nowritebackup            " disable backup/swap files
" set undofile undodir=~/.vim/undo undolevels=9999 " undo options

" Performace Tuning
" set lazyredraw                                   " enable lazyredraw
" set nocursorline                                 " disable cursorline
" set ttyfast                                      " enable fast terminal connection

" let mapleader=' '

cnoreabbrev w!! w !sudo tee > /dev/null %|       " write file with sudo
