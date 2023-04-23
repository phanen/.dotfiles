echo before local bashrc
# non-interactively
[[ $- != *i* ]] && return
echo local bashrc

PS1='[\u@\h \W]\$ '

export BASHRC_DIR=~/.config/bash # export simply for vim ....
[[ -r $BASHRC_DIR/utils.sh ]] && . "$BASHRC_DIR"/utils.sh

_util_append_path "$HOME/bin" "$XDG_DATA_HOME/nvim/mason/bin" "$HOME/.local/bin"

export JAVA_HOME="/opt/jdk-14"
_util_prepend_path "$JAVA_HOME/bin"

shopt -s autocd
shopt -s checkwinsize
set -o emacs

[[ -r $BASHRC_DIR/env.sh ]] && . $BASHRC_DIR/env.sh
[[ -r $BASHRC_DIR/alias.sh ]] && . $BASHRC_DIR/alias.sh
[[ -r $BASHRC_DIR/functions.sh ]] && . $BASHRC_DIR/functions.sh
[[ -r $BASHRC_DIR/keybindings.sh ]] && . $BASHRC_DIR/keybindings.sh
[[ -r $BASHRC_DIR/plugins.sh ]] && . $BASHRC_DIR/plugins.sh

[[ -z $MYVIMRC ]] && eval $FETCHER

[[ $(tty) = '/dev/tty1' ]] && 
  _util_netcfg &&
  cd ~ && startx &&
  sudo kbdrate -d 150 -r 65

# a handler to set keymap and keyrate
_util_post_x
