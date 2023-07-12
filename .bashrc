#!/usr/bin/env bash
# shellcheck disable=3010 source=/dev/null
# https://github.com/koalaman/shellcheck/wiki/SC1090

# non-interactively
[[ $- != *i* ]] && return

export BASHRC_DIR=~/.config/bash # export simply for `gf`....
[[ -r $BASHRC_DIR/utils.sh ]] && . $BASHRC_DIR/utils.sh
_util_append_path "$HOME/bin" "$XDG_DATA_HOME/nvim/mason/bin" "$HOME/.local/bin"
_util_append_path "$XDG_CONFIG_HOME/emacs/bin"


[[ -r $BASHRC_DIR/env.sh ]] && . $BASHRC_DIR/env.sh
[[ -r $BASHRC_DIR/alias.sh ]] && . $BASHRC_DIR/alias.sh
[[ -r $BASHRC_DIR/functions.sh ]] && . $BASHRC_DIR/functions.sh
[[ -r $BASHRC_DIR/plugins.sh ]] && . $BASHRC_DIR/plugins.sh

# disable tty ctrl-s
stty stop undef

# bash specific
which_shell=$(ps -o comm= -p $$) # or $BASH?
if [[ $which_shell == 'bash' ]]; then
	PS1='[\u@\h \W]\$ '
	shopt -s autocd checkwinsize
	# set -o emacs
	[[ -r $BASHRC_DIR/keybindings.sh ]] && . $BASHRC_DIR/keybindings.sh
fi

# [[ -z $MYVIMRC ]] && eval $FETCHER

case  $(tty) in
  *tty*) setfont ter-d28b;;
  *) ;;
esac

[ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ] && _util_netcfg && cd ~ && startx # && sudo kbdrate -d 150 -r 65


export NPC_HOME=/home/phanium/ysyx/ysyx-workbench/npc
export NEMU_HOME=/home/phanium/ysyx/ysyx-workbench/nemu
export NVBOARD_HOME=/home/phanium/ysyx/ysyx-workbench/nvboard
