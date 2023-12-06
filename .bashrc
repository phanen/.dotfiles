#!/usr/bin/env bash

# non-interactively
[[ $- != *i* ]] && return
[[ -f ~/.shellrc ]] && ~/.shellrc

PS1='[\u@\h \W]\$ '
shopt -s autocd checkwinsize
# set -o emacs
[[ -r $BASHRC_DIR/keybindings.sh ]] && . $BASHRC_DIR/keybindings.sh
