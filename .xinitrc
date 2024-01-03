#!/bin/sh
userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps
if [ -f $sysresources ]; then
	xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
	xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
	xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
	xmodmap "$usermodmap"
fi

# start some nice programs
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
	for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi


# setxkbmap -option caps:escape
# setxkbmap -option altwin:swap_alt_win

# possible for session-wise daemon, but: fcitx5/browser seems not work in multiply xdisplay
# _bootstrap() { if ! pgrep "$1"; then eval "$@" 2>&1 >/dev/null; fi }
fcitx5 -d
kmonad ~/.config/kmonad/kmonad-$(hostname).kbd -w 10 &
polybar -r &
picom &
dunst &
sxhkd -a Tab &
xsel -b --watch clipman store &
# timeout 1s ssh arch input-leapc && input-leaps --config inputleap.conf

# cliphist list | rofi -dmenu -display-columns 2 | cliphist decode | wl-copy
# swhks &
# pkexec swhkd &
# udiskie &

xrandr --auto

# export DESKTOP_SESSION=plasma
# exec google-chrome-stable
session=${1:-bspwm}
case $session in
    bspwm             ) exec bspwm;;
    dwm               ) exec dwm;;
    awesome           ) exec awesome;;
    kde               ) exec startplasma-x11;;
    xfce|xfce4        ) exec startxfce4;;
    leftwm            ) exec dbus-launch leftwm;;
    chromium          ) exec chromium;;
    *                 ) exec $1;;
esac
