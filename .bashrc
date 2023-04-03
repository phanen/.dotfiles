# non-interactively
[[ $- != *i* ]] && return

# better cd
[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh

# sudo wpa_supplicant -B -i wlp0s20f3 -c /etc/wpa_supplicant/wpa_supplicant.conf &&
# sudo kbdrate -d 150 -r 25

PS1='[\u@\h \W]\$ '

export EDITOR=nvim
export VISUAL=nvim
export TERMINAL=alacritty
[ -n "$DISPLAY" ] && export BROWSER=chromium || export BROWSER=links
export PDF="chromium"
export MANPAGER="/bin/sh -c \"col -b | vi -c 'set ft=man ts=8 nomod nolist nonu noma' -\""
# export PAGER="most"
# export LESS_TERMCAP_mb=$(printf '\e[01;31m') # enter blinking mode - red
# export LESS_TERMCAP_md=$(printf '\e[01;35m') # enter double-bright mode - bold, magenta
# export LESS_TERMCAP_me=$(printf '\e[0m')     # turn off all appearance modes (mb, md, so, us)
# export LESS_TERMCAP_se=$(printf '\e[0m')     # leave standout mode
# export LESS_TERMCAP_so=$(printf '\e[01;33m') # enter standout mode - yellow
# export LESS_TERMCAP_ue=$(printf '\e[0m')     # leave underline mode
# export LESS_TERMCAP_us=$(printf '\e[04;36m') # enter underline mode - cyan

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_DATA_DIRS="/usr/local/share:/usr/share"
export XDG_CONFIG_DIRS="/etc/xdg"

export JAVA_HOME="/opt/jdk-14"

append_path(){
    # [ "$(id -u)" -ge 1000 ] || return
    for p in "$@";
    do
        [ -d "$p" ] || continue
        echo "$PATH" | grep -Eq "(^|:)$p(:|$)" && continue
        export PATH="${PATH:+$PATH:}$p"
    done
}

prepend_path(){
    # [ "$(id -u)" -ge 1000 ] || return
    for p in "$@";
    do
        [ -d "$p" ] || continue
        echo "$PATH" | grep -Eq "(^|:)$p(:|$)" && continue
        export PATH="$p${PATH:+:$PATH}"
    done
}

append_path "$HOME/bin" "$XDG_DATA_HOME/nvim/mason/bin" "$HOME/.local/bin"
prepend_path "$JAVA_HOME/bin"

cdev() { append_path "$HOME/demo/dev/depot_tools"; }

# proxy
export http_proxy="http://localhost:7890"
export https_proxy="http://localhost:7890"
export all_proxy="http://localhost:7890"

shopt -s autocd
shopt -s checkwinsize

LFCD="$XDG_CONFIG_HOME/lf/lfcd.sh"
[ -f "$LFCD" ] && . "$LFCD"

# set -o vi
set -o emacs
xset r rate 200 45
# xinput --set-prop 16 'libinput Accel Speed' 1
# xset m 10 1

alias ls="lsd --color=auto"
alias ll="lsd -lah --color=auto"
alias l="ll"
alias rm="rm -i"
alias grep="grep --color"
alias chrome="chromium" ## --proxy-server=\"localhost:7890\""
alias du=dust
alias lt="ls --tree"
alias lta="ls -a --tree"
alias em="emacs -nw"
alias lg="lazygit"

alias rigdb="riscv64-linux-gnu-gdb"

alias uma="sudo umount -R /mnt"
alias todo="$EDITOR $HOME/TODO.md"
alias log="$EDITOR $HOME/LOG.md"
alias hm="l | wc -l"
alias nf="neofetch"
alias cdswap="cd $XDG_STATE_HOME/nvim/swap/"

alias ssu="sudo systemctl restart udevmon"
alias ssc="systemctl restart --user clash"
alias svi="sudo -E vi"
alias ni="neovide"
alias sni="sudo -E neovide"

# config
alias sb="source $HOME/.bashrc"
alias cb="$EDITOR $HOME/.bashrc"
alias ca="$EDITOR $XDG_CONFIG_HOME/alacritty/alacritty.yml"
alias cn="$EDITOR $XDG_CONFIG_HOME/nvim"
alias cs="$EDITOR $XDG_CONFIG_HOME/friendly-snippets/"
alias cf="$EDITOR $XDG_CONFIG_HOME/lf"
alias ct="$EDITOR $XDG_CONFIG_HOME/tmux/tmux.conf"
alias cg="$EDITOR $XDG_CONFIG_HOME/git/config"

## sdu wifi
# export sduwifi=101.76.193.1
sdulan() { nmcli dev wifi connect sdu_net; }
chtox() { chmod +x $1; }
reorder () { ls * | sort -n -t _ -k 2; }

# docker
alias doc="sudo systemctl start docker"
dop() {
  docker start "$1" && docker attach "$1";
}

# awesome fzf 
FZF_DIR=". $HOME/Downloads $HOME/mnt $HOME/QQ_recv"
fzp() { fzf --margin 5% --padding 5% --border --preview 'cat {}'; }
fcd() { cd $(dirname $(fzf)); }
fvi() { du -a $FZF_DIR | awk '{print $2}' | fzf | xargs -r $EDITOR;}
# fpd() { du -a $FZF_DIR | awk '{print $2}' | fzf --query pdf$ | xargs -r $PDF;}
fpd() { $PDF "$(fzf)" >/dev/null 2>&1; }
fmp() { mpv "$(fzf)" >/dev/null 2>&1; }

fhis() { stty -echo && history | grep ""$@ | awk '{$1=$2=$3=""; print $0}' | fzf | xargs -I {} xdotool type {}  && stty echo; }


fclash() {
    clash -d `echo -e "$XDG_CONFIG_HOME/clash/\n$XDG_CONFIG_HOME/clash/yy" | fzf`
}

calc() {
    echo "scale=3;$@" | bc -l
}

note () {
    if [[ ! -f $HOME/.notes ]]; then
        touch "$HOME/.notes"
    fi
    if ! (($#)); then
        cat "$HOME/.notes"
    elif [[ "$1" == "-c" ]]; then
        printf "%s" > "$HOME/.notes"
    else
        printf "%s\n" "$*" >> "$HOME/.notes"
    fi
}

gg() {
    if [[ ! -f $HOME/.todo ]]; then
        touch "$HOME/.todo"
    fi
    if ! (($#)); then
        cat "$HOME/.todo"
    elif [[ "$1" == "-l" ]]; then
        nl -b a "$HOME/.todo"
    elif [[ "$1" == "-c" ]]; then
        > $HOME/.todo
    elif [[ "$1" == "-r" ]]; then
        nl -b a "$HOME/.todo"
        eval printf %.0s- '{1..'"${COLUMNS:-$(tput cols)}"\}; echo
        read -p "键入要删除的数字: " number
        sed -i ${number}d $HOME/.todo "$HOME/.todo"
    else
        printf "%s\n" "$*" >> "$HOME/.todo"
    fi
}

ipif() { 
    if grep -P "(([1-9]\d{0,2})\.){3}(?2)" <<< "$1"; then
	 curl ipinfo.io/"$1"
    else
	ipawk=($(host "$1" | awk '/address/ { print $NF }'))
	curl ipinfo.io/${ipawk[1]}
    fi
    echo
}

ATHEME="$XDG_CONFIG_HOME"/alacritty/alacritty-theme/themes/
ACONFIG="$XDG_CONFIG_HOME"/alacritty/alacritty.yml
alswitch() { # alacritty switch theme
  theme=$(ls -1 "$ATHEME" | shuf -n1) 
  sed -i '3s/themes\/.*\.ya\?ml$/themes\/'$theme'/'  $ACONFIG
  echo "$theme"
  # xsetroot -name "$random_theme  $(date)"
}

sala() { # alacritty select theme
  theme=$(ls -1 "$ATHEME" | fzf) 
  sed -i '3s/themes\/.*\.ya\?ml$/themes\/'$theme'/'  $ACONFIG
  echo "$theme"
}

bala() { # alacritty blink theme
  while true; do alswitch && sleep 0.1; done > /dev/null
}

alias mx='chmod 755'
# export MANPAGER="/bin/sh -c \"col -b | vi -c 'set ft=man ts=8 nomod nolist nonu noma' -\""

## key bindings
bind '"\C-o":"\C-alfcd \C-e"'
bind '"\C-t":"$(compgen -c | fzf)"'
bind '"\C-v": "\C-avi \C-e"'
bind '"\es": "\C-asudo \C-e"'
bind '"\e\C-b": "\C-e > /dev/null 2>&1 &"'
bind '"\e\C-l": "\C-e | less"'
run-help() { help "$READLINE_LINE" 2>/dev/null || man "$READLINE_LINE"; }
bind -m vi-insert -x '"\eh": run-help'
bind -m emacs -x     '"\eh": run-help'


diskcheck() {
   sudo smartctl -a /dev/nvme0n1
   sudo smartctl -a /dev/nvme1n1
}


[[ -z $MYVIMRC ]] && uwufetch

[[ $(tty) = '/dev/tty1' ]] && 
  # sudo dhcpcd &&
  sudo rfkill unblock wifi &&
  # sudo ip a add 192.168.1.222/24 dev wlp0s20f3 &&
  # sudo ip r add default via 192.168.1.1 dev wlp0s20f3 &&
  systemctl restart --user clash &&
  cd ~ && startx

# source $HOME/bin/fzf-obc/bin/fzf-obc.bash
# source ~/.local/share/blesh/ble.sh
# eval "$(zoxide init bash)"
# eval "$(starship init bash)"
# source $HOME/bin/fzf-bash-cmp
# bind -x '"\t": /home/phanium/bin/fzf-bash-cmp'
