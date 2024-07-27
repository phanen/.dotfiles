functions -c alias old_alias

function alias
    set -l wraps --wraps (string escape -- $argv[2])
    eval "function $argv[1] $wraps; $argv[2] \$argv; end"
end

# note: when not prefixed with command, alias may be expanded recursively
# alias tree "command eza --tree"

# note: this cause failure in startup, `type` used by `__ksi_schedule` with prefix `builtin`
# alias type "builtin type -a"

# TODO: abbr
alias pi 'sudo pacman -S'
alias pd 'sudo pacman -Rns'
alias pdd 'sudo pacman -Rdd'
alias pid 'sudo pacman -S --asdeps'
alias pao 'pacman -Qo'
alias pfo 'pacman -F'
alias pai 'pacman -Qi'
alias pal 'pacman -Ql'
alias pfl 'pacman -Fl'
alias pas 'pacman -Qs'
alias pss 'pacman -Ss'
alias yss 'paru -Ss'
alias ysi 'paru -Si --nocheck'
alias yi 'paru -S'
alias pat 'pactree -lu'
alias par 'pactree -r -lu'
alias pst 'pactree -slu'
alias psr 'pactree -r -slu'

functions -e alias
functions -c old_alias alias

function pi --wrap pacman -S
    if test -z $argv
        sudo pacman -U (string join \n ~/.cache/paru/clone/*/*.pkg.tar.zst | fzf)
    else
        sudo pacman -S $argv
    end
end

function po --wrap ls
    # TODO: merge completion, ls + pacman -Qo
    # TODO: missing colorize...
    # FIXME: args to pkgfile should be sanitized (e.g. `/bin` -> `/bin/`, `/var/ -> /var/`)
    # FIXME: multiple args (pkgfile accept only one file)
    argparse -n po --max-args v/ vv/ = -- $argv

    pacman -Qo $argv
    or begin
        if command -q pkgfile
            if command -q $argv
                pkgfile -bv $argv
            else if test -d $argv
                pkgfile -dv $argv
            end
            pkgfile -v
        else
            pacman -F $argv
        end
    end
end


function vw
    if command -q $argv
        command $EDITOR (command -v $argv)
    else if functions -q $argv
        fe $argv
    end
end

function lw --wrap command
    if command -q $argv
        ls -lha (command -v $argv)
    end
end

# edit function and source it
# unlike funced, this prefer edit-in-place to create-new-function
function fe --wrap functions
    set -l res (functions --details $argv)

    if string match -q $res n/a
        $EDITOR ~/.config/fish/functions/$argv.fish
        source ~/.config/fish/functions/$argv.fish
    else
        $EDITOR $res
    end
end

function fw --wrap command
    if command -q $argv
        file (command -v $argv)
    end
end

function ldw --wrap command
    if command -q $argv
        ldd (command -v $argv)
    end
end

# TODO: merge completion, ls + pacman -Qo
function po --wrap ls
    pacman -Qo $argv || pacman -F $argv
end


function psi --wrap 'pacman -S'
    pacman -Qi $argv || pacman -Si $argv
end

function kssh
    infocmp -a xterm-kitty | /bin/ssh $argv tic -x -o \~/.terminfo /dev/stdin
end
