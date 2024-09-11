vim9script

# Download plug.vim if it doesn't exist yet
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

# Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)')) > 0
            \| PlugInstall --sync | source $MYVIMRC
            \| endif

plug#begin()
Plug 'airblade/vim-gitgutter'
# highlight misbehavior?
# Plug 'girishji/vimcomplete'
Plug 'girishji/autosuggest.vim'
Plug 'Eliot00/auto-pairs'
Plug 'habamax/vim-dir'
Plug 'Donaldttt/fuzzyy'
Plug 'girishji/scope.vim'
Plug 'hahdookin/miniterm.vim'
Plug 'yegappan/lsp'
Plug 'jessepav/vim-boxdraw'
Plug 'girishji/easyjump.vim'

Plug 'lacygoill/vim9asm'
Plug 'rafamadriz/friendly-snippets'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
# colorschemes
# Plug 'cocopon/iceberg.vim'
Plug 'dracula/vim'
# Plug 'girishji/declutter.vim'
# Plug 'girishji/bufline.vim'
# Plug 'girishji/ngram-complete.vim'
# Plug 'girishji/pythondoc.vim', {'for': 'python'}
# Plug 'girishji/fFtT.vim'
# Plug 'girishji/devdocs.vim'


Plug 'ZSaberLv0/ZFVimJob' # required for job impl
Plug 'ZSaberLv0/ZFVimTerminal'
nnoremap <leader>zs :ZFTerminal<space>
plug#end()

# import autoload 'scope/fuzzy.vim'
# nn +<c-f> <scriptcmd>fuzzy.File($'find {$VIMRUNTIME} -type f -print -follow')<cr>
# nn <leader><c-f> <scriptcmd>fuzzy.File(fuzzy.FindCmd($VIMRUNTIME))<CR>
#
# def FindGit()
#     var gitdir = system("git rev-parse --show-toplevel 2>/dev/null")->trim()
#     if v:shell_error != 0 || gitdir == getcwd()
#         gitdir = '.'
#     endif
#     fuzzy.File(fuzzy.FindCmd(gitdir))
# enddef
#
# nn <c-l> <scriptcmd>FindGit()<cr>
#
# # Not-forced not-emptied boxes
# vnoremap <Leader>bs <Esc><Cmd>BoxDraw single<CR>
# vnoremap <Leader>bd <Esc><Cmd>BoxDraw double<CR>
# vnoremap <Leader>br <Esc><Cmd>BoxDraw rounded<CR>
# vnoremap <Leader>ba <Esc><Cmd>BoxDraw ascii<CR>
# vnoremap <Leader>bc <Esc><Cmd>BoxDraw clear<CR>
# vnoremap <Leader>bb <Esc><Cmd>BoxDraw<CR>
#
# # Not-forced emptied boxes
# vnoremap <Leader>bes <Esc><Cmd>BoxDraw single false true<CR>
# vnoremap <Leader>bed <Esc><Cmd>BoxDraw double false true<CR>
# vnoremap <Leader>ber <Esc><Cmd>BoxDraw rounded false true<CR>
# vnoremap <Leader>bea <Esc><Cmd>BoxDraw ascii false true<CR>
# vnoremap <Leader>bec <Esc><Cmd>BoxDraw clear false true<CR>
#
# # Diagonals (always 'single' style)
# vnoremap <Leader>b/ <Esc><Cmd>BoxDraw DIAGONAL_FORWARD<CR>
# vnoremap <Leader>b <Esc><Cmd>BoxDraw DIAGONAL_BACKWARD<CR>
#
# # Selection
# vnoremap <Leader>bl <Esc><Cmd>BoxDraw SELECTBOX<CR>
#
# # Forced not-emptied boxes
# vnoremap <Leader>BS <Esc><Cmd>BoxDraw single true<CR>
# vnoremap <Leader>BD <Esc><Cmd>BoxDraw double true<CR>
# vnoremap <Leader>BR <Esc><Cmd>BoxDraw rounded true<CR>
# vnoremap <Leader>BA <Esc><Cmd>BoxDraw ascii true<CR>
# vnoremap <Leader>BC <Esc><Cmd>BoxDraw clear true<CR>
# vnoremap <Leader>BB <Esc><Cmd>BoxDraw IBID true<CR>
#
# # Forced emptied boxes
# vnoremap <Leader>BES <Esc><Cmd>BoxDraw single true true<CR>
# vnoremap <Leader>BED <Esc><Cmd>BoxDraw double true true<CR>
# vnoremap <Leader>BER <Esc><Cmd>BoxDraw rounded true true<CR>
# vnoremap <Leader>BEA <Esc><Cmd>BoxDraw ascii true true<CR>
# vnoremap <Leader>BEC <Esc><Cmd>BoxDraw clear true true<CR>
#
# # Normal mode selection
# nnoremap <Leader><Leader>bl <Cmd>BoxDraw SELECTBOX<CR>
#
# # One-key meta shortcuts
# vnoremap <M-b> <Esc><Cmd>BoxDraw<CR>
# vnoremap <M-B> <Esc><Cmd>BoxDraw IBID true<CR>
# vnoremap <M-l> <Esc><Cmd>BoxDraw SELECTBOX<CR>
# nnoremap <M-l> <Cmd>BoxDraw SELECTBOX<CR>
#
# import autoload 'comment.vim'
# nnoremap <silent> <expr> gc comment.Toggle()
# xnoremap <silent> <expr> gc comment.Toggle()
# nnoremap <silent> <expr> gcc comment.Toggle() .. '_'
