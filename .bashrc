echo before local bashrc
# non-interactively
[[ $- != *i* ]] && return

# better cd
[[ -r "/usr/share/z/z.sh" ]] && . /usr/share/z/z.sh
echo local bashrc

PS1='[\u@\h \W]\$ '
export BASHRC_DIR=$HOME/.bash

[[ -r $BASHRC_DIR/utils.sh ]] && . "$BASHRC_DIR"/utils.sh

append_path "$HOME/bin" "$XDG_DATA_HOME/nvim/mason/bin" "$HOME/.local/bin"

export JAVA_HOME="/opt/jdk-14"
prepend_path "$JAVA_HOME/bin"

shopt -s autocd
shopt -s checkwinsize
set -o emacs
xset r rate 200 45

[[ -r $BASHRC_DIR/env.sh ]] && . $BASHRC_DIR/env.sh
[[ -r $BASHRC_DIR/alias.sh ]] && . $BASHRC_DIR/alias.sh
[[ -r $BASHRC_DIR/functions.sh ]] && . $BASHRC_DIR/functions.sh
[[ -r $BASHRC_DIR/keybindings.sh ]] && . $BASHRC_DIR/keybindings.sh

[[ -z $MYVIMRC ]] && uwufetch

[[ $(tty) = '/dev/tty1' ]] && 
  # sudo dhcpcd &&
  sudo kbdrate -d 150 -r 25 &&
  # xset m 10 1
  sudo rfkill unblock wifi &&
  # sudo ip a add 192.168.1.222/24 dev wlp0s20f3 &&
  # sudo ip r add default via 192.168.1.1 dev wlp0s20f3 &&
  systemctl restart --user clash &&
  cd ~ && startx

[[ -r $BASHRC_DIR/plugins.sh ]] && . $BASHRC_DIR/plugins.sh

# xinput --set-prop 16 'libinput Accel Speed' 1
# sudo wpa_supplicant -B -i wlp0s20f3 -c /etc/wpa_supplicant/wpa_supplicant.conf &&
