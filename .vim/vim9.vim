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
