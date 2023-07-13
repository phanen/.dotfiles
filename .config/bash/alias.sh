alias e='$EDITOR'
alias v='nvim'
alias k='pkill'
alias x='xsel'
alias t="type"
alias p="sudo pacman"
alias y="yay"

alias ls="exa --color=auto"
alias ll="ls -lah"
alias la="ls -a"
alias l="ll"
alias lt="ls --tree"
alias lta="ls -a --tree"
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
alias si="sudo -E vi"
alias du="dust"
alias em="emacs -nw"
alias hl="helix"
alias nf="uwufetch"
alias lg="lazygit"

alias ua="sudo umount -R /mnt"
alias hm="l | wc -l"
alias cs="cd $XDG_STATE_HOME/nvim/swap/"
alias ok='echo $status'
alias km='pkill kmonad; kmonad ~/.config/kmonad/kmonad.kbd -w 50 & disown'

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
alias ys='yay -Ss'
alias yss='yay -Ss'
alias ysi='yay -Si'
alias yi='yay -S'

alias patt='pactree -lu'
alias pat='pactree -d 1 -lu'
alias par='pactree -r -lu'
alias pst='pactree -slu'
alias psr='pactree -slu'

alias ap="md /tmp/tmp; yay -G"
alias apt="asp export"
alias mkp="makepkg -do --skippgpcheck"

# podman
alias pov='podman volume'
alias por='podman run'

alias todo="$EDITOR $HOME/notes/todo.md"
alias log="$EDITOR $HOME/LOG.md"
alias vifm='vifmrun'
alias rigdb="riscv64-linux-gnu-gdb"
alias wezterm='flatpak run org.wezfurlong.wezterm'
alias foliate='flatpak run com.github.johnfactotum.Foliate'
