#!/usr/bin/env bash
# shellcheck disable=3010 source=/dev/null
# https://github.com/koalaman/shellcheck/wiki/SC1090

# non-interactively
[[ $- != *i* ]] && return

export BASHRC_DIR=$HOME/.config/bash # simply for `gf`...
[[ -r $BASHRC_DIR/utils.sh ]] && . $BASHRC_DIR/utils.sh
[[ -r $BASHRC_DIR/env.sh ]] && . $BASHRC_DIR/env.sh

# workaround: in fish, the $PATH is split by space, so we add one by one
_util_append_path "$HOME/bin"
_util_append_path "$XDG_DATA_HOME/nvim/mason/bin"
_util_append_path "$HOME/.local/bin"
_util_append_path "$HOME/.cargo/bin"
_util_append_path "$XDG_CONFIG_HOME/emacs/bin"

[[ -r $BASHRC_DIR/alias.sh ]] && . $BASHRC_DIR/alias.sh
[[ -r $BASHRC_DIR/functions.sh ]] && . $BASHRC_DIR/functions.sh
[[ -r $BASHRC_DIR/plugins.sh ]] && . $BASHRC_DIR/plugins.sh

# bash specific
which_shell=$(ps -o comm= -p $$) # or $BASH?
if [[ "$which_shell" == "bash" ]]; then
	PS1='[\u@\h \W]\$ '
	shopt -s autocd checkwinsize
	# set -o emacs
	[[ -r $BASHRC_DIR/keybindings.sh ]] && . $BASHRC_DIR/keybindings.sh
fi

# disable tty ctrl-s
[[ "$which_shell" != fish ]] && stty stop undef

# [[ -z $MYVIMRC ]] && eval $FETCHER

case  $(tty) in
  *tty*) setfont ter-d28b;;
  *) ;;
esac

# _util_netcfg
# [ -z "${SSH_TTY}" ] && [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ] && cd ~ && startx # && sudo kbdrate -d 150 -r 65
