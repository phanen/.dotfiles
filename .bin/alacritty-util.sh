#!/bin/bash
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
