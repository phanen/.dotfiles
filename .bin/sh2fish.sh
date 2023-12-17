#!/bin/sh

SHELLRC=~/.shellrc
FISH_COMMON=~/.config/fish/sh-common.fish
cat ${SHELLRC} | sed 's/^.*\]\] && \./cat/e' | sed '/^[[:blank:]]*#/d;s/#.*//' | babelfish > ${FISH_COMMON}
[[ $(tty) != /dev/tty* ]] && dunstify sh2fish || exit 0
