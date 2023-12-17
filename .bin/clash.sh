#!/bin/sh
CLASH_CONFIG=$(find ~/.config/clash -type f -name "*.yaml" | fzf)
[[ -f $CLASH_CONFIG ]] || exit
# https://github.com/kovidgoyal/kitty/issues/307
nohup /bin/clash -f $CLASH_CONFIG >/dev/null 2>/dev/null & disown; exit
