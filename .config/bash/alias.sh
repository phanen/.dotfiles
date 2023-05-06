alias ls="exa --color=auto"
alias ll="ls -lah --color=auto"
alias la="ls -a --color=auto"
alias l="ll"
alias lt="ls --tree"
alias lta="ls -a --tree"
alias type="type -a"
alias t="type -a"
alias which="which -a"
alias grep="grep --color"
alias rm="rm -i"
alias df="df -h"
alias mx='chmod +x'
alias hx='hexdump'

alias vi='nvim'
alias vn='vi -u NONE'
alias ni="nvim"
alias sni="sudo -E ni"

alias paru='paru --bottomup'
alias pao='pacman -Qo'
alias pfo='pacman -F'
alias pai='pacman -Qi'
alias psi='pacman -Si'
alias pal='pacman -Ql'
alias pfl='pacman -Fl'
alias pas='pacman -Qs'
alias pss='pacman -Ss'
alias pat='pactree -lu --color'
alias pst='pactree -slu --color'

alias k='pkill'
alias x='xsel'

alias du="dust"
alias em="emacs -nw"
# alias hx="helix"
alias nf="uwufetch"
alias lg="lazygit"
alias chrome="chromium" ## --proxy-server=\"localhost:7890\""

alias rigdb="riscv64-linux-gnu-gdb"

alias uma="sudo umount -R /mnt"
alias todo="$EDITOR $HOME/notes/todo.md"
alias log="$EDITOR $HOME/LOG.md"
alias hm="l | wc -l"
alias cdswap="cd $XDG_STATE_HOME/nvim/swap/"

alias ssu="sudo systemctl restart udevmon"

# config
alias sb="source $HOME/.bashrc"
alias c="$EDITOR $HOME"

# docker
alias doc="sudo systemctl start docker"
alias pov='podman volume'
alias por='podman run'

# fuck
alias ok='echo $?'
alias km='pkill kmonad; kmonad ~/.config/kmonad/kmonad.kbd -w 50 & disown'
