#!/bin/sh
pkill -x clash
CLASH_CONFIG=$(find ~/.config/clash -type f -name "*.yaml" | fzf)
[[ -f $CLASH_CONFIG ]] || exit
# https://github.com/kovidgoyal/kitty/issues/307
/bin/clash -f $CLASH_CONFIG &>/dev/null & disown
