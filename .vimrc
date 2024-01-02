" https://github.com/skwp/dotfiles/blob/master/vimrc
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
let mapleader=' '
cnoreabbrev w!! w !sudo tee > /dev/null %|       " write file with sudo
