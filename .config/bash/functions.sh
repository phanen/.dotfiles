#!/usr/bin/env bash
# shellcheck source=/dev/null

## sdu wifi
# export sduwifi=101.76.193.1
sdulan() { nmcli dev wifi connect sdu_net; }
reorder() { ls * | sort -n -t _ -k 2; }

dop() {
	docker start "$1" && docker attach "$1"
}

LFCD="$XDG_CONFIG_HOME/lf/lfcd.sh"
[ -f "$LFCD" ] && . "$LFCD"

# awesome fzf
FZF_DIR=". $HOME/Downloads $HOME/mnt $HOME/QQ_recv"
fsl() { fzf -m --margin 5% --padding 5% --border --preview 'cat {}'; }
fp() { fzf | tr -d "\n" | xsel -b; }
frm() { fsl | rm; }

# fpd() { du -a $FZF_DIR | awk '{print $2}' | fzf --query pdf$ | xargs -r $PDF;}
fpd() { $PDF "$(fzf)" >/dev/null 2>&1; }
fmp() { mpv "$(fzf)" >/dev/null 2>&1; }

fhs() { stty -echo && history | grep ""$@ | awk '{$1=$2=$3=""; print $0}' | fzf | xargs -I {} xdotool type {} && stty echo; }

fcl() {
	(
		cd "${XDG_CONFIG_HOME}"/clash/ || exit
		ln -sf $(ls *.yaml | fzf) config.yaml
		clash
	)
}

calc() {
	echo "scale=3;$@" | bc -l
}


ipif() {
	if grep -P "(([1-9]\d{0,2})\.){3}(?2)" <<<"$1"; then
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
	sed -i '3s/themes\/.*\.ya\?ml$/themes\/'$theme'/' $ACONFIG
	echo "$theme"
	# xsetroot -name "$random_theme  $(date)"
}

sala() { # alacritty select theme
	theme=$(ls -1 "$ATHEME" | fzf)
	sed -i '3s/themes\/.*\.ya\?ml$/themes\/'$theme'/' $ACONFIG
	echo "$theme"
}

bala() { # alacritty blink theme
	while true; do alswitch && sleep 0.1; done >/dev/null
}
diskcheck() {
	sudo smartctl -a /dev/nvme0n1
	sudo smartctl -a /dev/nvme1n1
}

archman() { curl -sL "https://man.archlinux.org/man/$1.raw" | man -l -; }

toggle_proxy() {
	unset http_proxy
	unset https_proxy
	unset all_proxy
}

clip2img() {
	xclip -selection clipboard -target image/png -o >$1.png
}

# penv() {
# 	. $HOME/demo/pydemo/tele/bin/activate
# }

function vis() {
	local CONFIG="$(find ~/.config/nvim*/ -prune -exec basename {} \;)"
	local SELECTED=$(printf "%s\n" "${CONFIG[@]}" | fzf --prompt="Neovim Config >>" --height=~50% --layout=reverse --border --exit-0)
	echo $SELECTED
	if [[ -z $SELECTED ]]; then
		echo "Nothing selected"
		return 0
	elif [[ $SELECTED == "default" ]]; then
		SELECTED=""
	fi
	NVIM_APPNAME=$SELECTED nvim $@
}

function gitit() {
	cat <<EOF | sh
        git remote add origin git@github.com:phanen/phanen.git
        git branch -M master
        git push -u origin master
EOF
}

function vw() {
	vi "$(which $1 |head -1)"
}

function fw() {
	file "$(which $1 |head -1)"
}

function lw() {
	ls -la "$(which $1 |head -1)"
}


nnn-preview ()
{
    # Block nesting of nnn in subshells
    if [ -n "$NNNLVL" ] && [ "${NNNLVL:-0}" -ge 1 ]; then
        echo "nnn is already running"
        return
    fi

    # The default behaviour is to cd on quit (nnn checks if NNN_TMPFILE is set)
    # If NNN_TMPFILE is set to a custom path, it must be exported for nnn to see.
    # To cd on quit only on ^G, remove the "export" and set NNN_TMPFILE *exactly* as this:
    #     NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # This will create a fifo where all nnn selections will be written to
    NNN_FIFO="$(mktemp --suffix=-nnn -u)"
    export NNN_FIFO
    (umask 077; mkfifo "$NNN_FIFO")

    # Preview command
    preview_cmd="/home/phanium/.config/nnn/preview_cmd.sh"

    # Use `tmux` split as preview
    if [ -e "${TMUX%%,*}" ]; then
        tmux split-window -e "NNN_FIFO=$NNN_FIFO" -dh "$preview_cmd"

    # Use `xterm` as a preview window
    elif (which xterm &> /dev/null); then
        alacritty -e "$preview_cmd" &
        # xterm -e "$preview_cmd" &
    # Unable to find a program to use as a preview window
    else
        echo "unable to open preview, please install tmux or xterm"
    fi

    nnn "$@"

    rm -f "$NNN_FIFO"
}

zz() {
	tar -c --use-compress-program=pigz -f "$1".tar.gz $1
}

ddd() {
	dd bs=4M if="$1" of="$2" status=progress && sync
}
