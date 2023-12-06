#!/bin/bash

SHELLRC=~/.shellrc
FISH_COMMON=~/.config/fish/sh-common.fish
cat ${SHELLRC} | sed 's/^.*\]\] && \./cat/e' | sed '/^[[:blank:]]*#/d;s/#.*//' | babelfish > ${FISH_COMMON}

notify-send sh2fish
