alias ls="exa --color=auto"
alias ll="exa -lah --color=auto"
alias l="ll"
alias lt="ls --tree"
alias lta="ls -a --tree"
alias type="type -a"
alias t="type -a"
alias which="which -a"
alias grep="grep --color"
alias rm="rm -i"
alias rfa="rm -rf"
alias df="df -h"
alias pc="pacman"
alias mx='chmod 755'
alias hx='hexdump'
alias vi='nvim'
alias vn='vi -u NONE'

alias pa='paru --bottomup'
alias pao='pacman -Qo'
alias pai='pacman -Qi'
alias pal='pacman -Ql'
alias pas='pacman -Ss'
alias pat='pactree --color'
alias k='pkill'
alias x='xsel'

alias find="fd"
alias du="dust"
alias em="emacs -nw"
# alias hx="helix"
alias nf="neofetch"
alias lg="lazygit"
alias chrome="chromium" ## --proxy-server=\"localhost:7890\""
alias cm="chromium"

alias rigdb="riscv64-linux-gnu-gdb"

alias uma="sudo umount -R /mnt"
alias todo="$EDITOR $HOME/notes/todo.md"
alias log="$EDITOR $HOME/LOG.md"
alias hm="l | wc -l"
alias cdswap="cd $XDG_STATE_HOME/nvim/swap/"

alias ssu="sudo systemctl restart udevmon"
alias ssc="systemctl restart --user clash"
alias ni="nvim"
alias sni="sudo -E ni"

# config
alias sb="source $HOME/.bashrc"
alias cb="$EDITOR $XDG_CONFIG_HOME/bash"
alias ca="$EDITOR $XDG_CONFIG_HOME/alacritty"
alias cn="$EDITOR $XDG_CONFIG_HOME/nvim"
alias cf="$EDITOR $XDG_CONFIG_HOME/lf"
alias ct="$EDITOR $XDG_CONFIG_HOME/tmux/"
alias cg="$EDITOR $XDG_CONFIG_HOME/git/config"

# docker
alias doc="sudo systemctl start docker"

# fuck
alias ok='echo $?'
alias km='pkill kmonad; kmonad ~/.config/kmonad/kmonad.kbd & disown'
