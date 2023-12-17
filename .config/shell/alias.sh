alias v='nvim'
alias k='pkill'
alias x='xsel'
alias t="type"
alias p="sudo pacman"
alias y="yay"
alias s="sysz"

alias ls="exa --color=auto"
alias ll="ls -lah"
alias la="ls -a"
alias l="ll"
alias lt="ls --tree"
alias grep="grep --color"
# alias rm="rm -i"
alias df="df -h"
alias which="which -a"
alias type="type -a"

alias hx='hexdump'
alias tl='tldr'
alias mx='chmod +x'
alias rx='chmod -x'
alias vi='nvim'
alias vn='vi -u NONE'
# alias si="sudo -E vi"
alias si="sudoedit"
alias du="dust"
alias em="emacs -nw"
alias hl="helix"
alias nf="uwufetch"
alias lg="lazygit"

alias ua="sudo umount -R /mnt"
alias hm="l | wc -l"
alias cs="cd $XDG_STATE_HOME/nvim/swap/"
alias ok='echo $status'
alias kc='pkill kmonad; kmonad ~/.config/kmonad/kmonad-cb.kbd -w 50 & disown'
alias kh='pkill kmonad; kmonad ~/.config/kmonad/kmonad-hs.kbd -w 50 & disown'

# pacman
alias pi='sudo pacman -S'
alias pd='sudo pacman -Rns'
alias pu='sudo pacman -Syu'
alias pao='pacman -Qo'
alias pfo='pacman -F'
alias pai='pacman -Qi'
alias psi='pacman -Si'
alias pal='pacman -Ql'
alias pfl='pacman -Fl'
alias pag='pacman -Ql 2>&1|rg'
alias pfg='pacman -Fl 2>&1|rg'
alias pas='pacman -Qs'
alias pss='pacman -Ss'
alias psc='pacscripts'
alias ys='yay -Ss'
alias yss='yay -Ss'
alias ysi='yay -Si'
alias yi='yay -S'

alias patt='pactree -lu'
alias pato='pactree -d 1 -o -lu'
alias pat='pactree -d 1 -lu'
alias par='pactree -r -lu'
alias pst='pactree -slu'
alias psr='pactree -r -slu'

alias apt="asp export"
alias mkp="makepkg -do --skippgpcheck"

# podman
alias pov='podman volume'
alias por='podman run'

alias vifm='vifmrun'
alias ppush="rclone sync papers gd:papers -P"
alias ppull="rclone sync gd:papers papers -P"