# non-interactively
[[ $- != *i* ]] && return

export BASHRC_DIR=~/.config/bash # export simply for vim ....
[[ -r $BASHRC_DIR/utils.sh ]] && . "$BASHRC_DIR"/utils.sh

_util_append_path "$HOME/bin" "$XDG_DATA_HOME/nvim/mason/bin" "$HOME/.local/bin"
export JAVA_HOME="/opt/jdk-14"
_util_prepend_path "$JAVA_HOME/bin"

_util_append_path "$XDG_CONFIG_HOME/emacs/bin"

[[ -r $BASHRC_DIR/env.sh ]] && . $BASHRC_DIR/env.sh
[[ -r $BASHRC_DIR/alias.sh ]] && . $BASHRC_DIR/alias.sh
[[ -r $BASHRC_DIR/functions.sh ]] && . $BASHRC_DIR/functions.sh
[[ -r $BASHRC_DIR/plugins.sh ]] && . $BASHRC_DIR/plugins.sh

stty stop undef		# disable ctrl-s

# bash specific
CUR_SHELL=$(ps -o comm= -p $$) # or $BASH?
if [[ $CUR_SHELL == 'bash' ]]; then
    PS1='[\u@\h \W]\$ '
    shopt -s autocd checkwinsize
    # set -o emacs
    [[  -r $BASHRC_DIR/keybindings.sh ]] && . $BASHRC_DIR/keybindings.sh
fi

# [[ -z $MYVIMRC ]] && eval $FETCHER

[ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ] && _util_netcfg && cd ~ && startx # && sudo kbdrate -d 150 -r 65
