## sdu wifi
# export sduwifi=101.76.193.1
sdulan() { nmcli dev wifi connect sdu_net; }
chtox() { chmod +x $1; }
reorder () { ls * | sort -n -t _ -k 2; }

dop() {
  docker start "$1" && docker attach "$1";
}

LFCD="$XDG_CONFIG_HOME/lf/lfcd.sh"
[ -f "$LFCD" ] && . "$LFCD"

# awesome fzf 
FZF_DIR=". $HOME/Downloads $HOME/mnt $HOME/QQ_recv"
fsl() { fzf -m --margin 5% --padding 5% --border --preview 'cat {}'; }
frm() { fsl | rm; }
# fpd() { du -a $FZF_DIR | awk '{print $2}' | fzf --query pdf$ | xargs -r $PDF;}
fpd() { $PDF "$(fzf)" >/dev/null 2>&1; }
fmp() { mpv "$(fzf)" >/dev/null 2>&1; }

fhs() { stty -echo && history | grep ""$@ | awk '{$1=$2=$3=""; print $0}' | fzf | xargs -I {} xdotool type {}  && stty echo; }
fcl() { clash -d `echo -e "$XDG_CONFIG_HOME/clash/\n$XDG_CONFIG_HOME/clash/yy" | fzf`; }

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

diskcheck() {
   sudo smartctl -a /dev/nvme0n1
   sudo smartctl -a /dev/nvme1n1
}

archman() { curl -sL "https://man.archlinux.org/man/$1.raw" | man -l -; }
