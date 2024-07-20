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

fcitx5 -d &
# systemctl start --user xdg-desktop-autostart.target
polybar -r &
# picom &
# dunst &
sxhkd -a Tab &
# input-leaps --disable-crypto --config ~/.config/InputLeap/server.conf &
# input-leapc --disable-crypto --server arch
# xrandr --auto
# xrandr -o right

~/.bin/xrate-refresh.sh

# avoid firefox tearing in external monitor
# nvidia-settings --assign CurrentMetaMode="$(xrandr | sed -nr '/(\S+) connected (primary )?([0-9]+x[0-9]+)(\+\S+).*/{ s//\1: \3 \4 { ForceFullCompositionPipeline = On }, /; H}; ${ g; s/\n//g; s/, $//; p }')" &

# TODO: idw how to make xorg.conf ignore, but it really work well now...
# https://superuser.com/questions/626482/permanently-disable-second-screen
# xrandr --output eDP-1-2 --off
# autorandr --change docked

case $1 in
i3) exec i3 ;;
kde) DESKTOP_SESSION=plasma exec startplasma-x11 ;;
xfce) exec startxfce4 ;;
leftwm) exec dbus-launch leftwm ;;
*) exec ${1:-bspwm} ;;
esac
