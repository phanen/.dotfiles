alias ls="lsd --color=auto"
alias ll="lsd -lah --color=auto"
alias l="ll"
alias lt="ls --tree"
alias lta="ls -a --tree"
alias type="type -a"
alias which="which -a"
alias grep="grep --color"
alias rm="rm -i"
alias rfa="rm -rf"
alias df="df -h"

alias find="fd"
alias du="dust"
alias em="emacs -nw"
alias hx="helix"
alias nf="neofetch"
alias lg="lazygit"
alias chrome="chromium" ## --proxy-server=\"localhost:7890\""
alias cm="chromium"

alias rigdb="riscv64-linux-gnu-gdb"

alias uma="sudo umount -R /mnt"
alias todo="$EDITOR $HOME/TODO.md"
alias log="$EDITOR $HOME/LOG.md"
alias hm="l | wc -l"
alias cdswap="cd $XDG_STATE_HOME/nvim/swap/"

alias ssu="sudo systemctl restart udevmon"
alias ssc="systemctl restart --user clash"
alias ni="nvim"
alias sni="sudo -E ni"

# config
alias sb="source $HOME/.bashrc"
alias cb="$EDITOR $HOME/.bash"
alias ca="$EDITOR $XDG_CONFIG_HOME/alacritty/alacritty.yml"
alias cn="$EDITOR $XDG_CONFIG_HOME/nvim"
alias cs="$EDITOR $XDG_CONFIG_HOME/friendly-snippets/"
alias cf="$EDITOR $XDG_CONFIG_HOME/lf"
alias ct="$EDITOR $XDG_CONFIG_HOME/tmux/tmux.conf"
alias cg="$EDITOR $XDG_CONFIG_HOME/git/config"


# docker
alias doc="sudo systemctl start docker"
