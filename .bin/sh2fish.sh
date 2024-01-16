#!/bin/sh

SHELLRC=~/.shellrc
FISH_COMMON=~/.config/fish/sh-common.fish
cat ${SHELLRC} | sed '/^[[:blank:]]*#/d;s/#.*//' | babelfish > ${FISH_COMMON}
[[ $(tty) != /dev/tty* && -z $SSH_TTY ]] && dunstify sh2fish || exit 0
