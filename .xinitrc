#!/bin/sh
userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps
[ -f $sysresources ] && xrdb -merge $sysresources
[ -f $sysmodmap ] && xmodmap $sysmodmap
[ -f "$userresources" ] && xrdb -merge "$userresources"
[ -f "$usermodmap" ] && xmodmap "$usermodmap"

# start some nice programs
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

fcitx5 -d &
polybar -r &
picom &
dunst &
sxhkd -a Tab &
input-leaps --disable-crypto --config ~/.config/InputLeap/server.conf &
while clipnotify; do xclip -o -selection c | cliphist store; done &
input-leapc --disable-crypto --server arch
xrandr --auto
# xrandr -o right
~/.bin/xrate-refresh.sh

case $1 in
i3) exec i3 ;;
kde) DESKTOP_SESSION=plasma exec startplasma-x11 ;;
xfce) exec startxfce4 ;;
leftwm) exec dbus-launch leftwm ;;
*) exec ${1:-bspwm} ;;
esac
