function alias
    set -l wraps --wraps (string escape -- $argv[2])
    eval "function $argv[1] $wraps; $argv[2] \$argv; end"
end

alias f __zoxide_z
alias l "eza -1"
alias t "type -a"
alias v nvim

alias df "command df -h"
alias la "eza -a"
alias ls "eza --color=auto"
alias lt "eza --tree"
alias tl tldr
alias wh "which -a"

alias pi 'sudo pacman -S'
alias pd 'sudo pacman -Rns'
alias pdi 'sudo pacman -S --asdeps'
alias pao 'pacman -Qo'
alias pfo 'pacman -F'
alias pai 'pacman -Qi'
alias pal 'pacman -Ql'
alias pfl 'pacman -Fl'
alias pas 'pacman -Qs'
alias pss 'pacman -Ss'
alias yss 'paru -Ss'
alias ysi 'paru -Si'
alias yi 'paru -S'
alias pat 'pactree -lu'
alias par 'pactree -r -lu'
alias pst 'pactree -slu'
alias psr 'pactree -r -slu'

alias dm 'v (fd .  ~/dot -d 1 | fzf)'

function fe --wrap functions
    v (functions --details $argv)
end

function vw
    if command -q $argv
        v (command -v $argv)
    else if functions -q $argv
        fe $argv
    end
end

function lw
    if command -q $argv
        exa -la (command -v $argv)
    end
end

function fw
    if command -q $argv
        file (command -v $argv)
    end
end

function ldw
    if command -q $argv
        ldd (command -v $argv)
    end
end

function po --wrap 'pacman -Qo'
    pacman -Qo $argv || pacman -F $argv
end

function psi
    pacman -Qi $argv || pacman -Si $argv
end
