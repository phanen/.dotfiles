#!/usr/bin/env bash

alias ls="exa --color=auto"
alias ll="ls -lah"
alias la="ls -a"
alias l="ll"
alias lt="ls --tree"
alias lta="ls -a --tree"

alias type="type -a"
alias which="which -a"
alias grep="grep --color"
alias rm="rm -i"
alias df="df -h"
alias mx='chmod +x'
alias hx='hexdump'
alias tl='tldr'

alias pi='sudo pacman -S'
alias pd='sudo pacman -Rns'
alias pau='sudo pacman -Syu'
alias pao='pacman -Qo'
alias pfo='pacman -F'
alias pai='pacman -Qi'
alias psi='pacman -Si'
alias pal='pacman -Ql'
alias pfl='pacman -Fl'
alias pas='pacman -Qs'
alias pss='pacman -Ss'

alias ys='yay -Ss'
alias yii='yay -Si'
alias yi='yay -S'

alias patt='pactree -lu'
alias pat='pactree -d 1 -lu'
alias par='pactree -r -lu'
alias pst='pactree -slu'
alias psr='pactree -slu'

alias apt="asp export"
alias mkp="makepkg -do --skippgpcheck"

alias vi='nvim'
alias vn='vi -u NONE'
alias si="sudo -E vi"
alias du="dust"
alias em="emacs -nw"
# alias hx="helix"
alias nf="uwufetch"
alias lg="lazygit"
alias chrome="google-chrome-stable" ## --proxy-server=\"localhost:7890\""

alias rigdb="riscv64-linux-gnu-gdb"

alias uma="sudo umount -R /mnt"
alias todo="$EDITOR $HOME/notes/todo.md"
alias log="$EDITOR $HOME/LOG.md"
alias hm="l | wc -l"
alias cdswap="cd $XDG_STATE_HOME/nvim/swap/"

alias ssu="sudo systemctl restart udevmon"

# config
alias sb="source $HOME/.zshrc"

# docker
alias doc="sudo systemctl start docker"
alias pov='podman volume'
alias por='podman run'

# fuck
alias ok='echo $?'
alias km='pkill kmonad; kmonad ~/.config/kmonad/kmonad.kbd -w 50 & disown'

alias v='nvim'
alias k='pkill'
alias x='xsel'
alias t="type"
alias p="sudo pacman"

# flatpak
alias wezterm='flatpak run org.wezfurlong.wezterm'
alias foliate='flatpak run com.github.johnfactotum.Foliate'

alias vifm='vifmrun'

# alias ap="asp export"
alias ap="md /tmp/tmp; yay -G"
