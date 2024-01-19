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

fcitx5 -d
polybar -r &
picom &
dunst &
sxhkd -a Tab &
while clipnotify; do xclip -o -selection c | cliphist store; done &
xrandr --auto

case $session in
    i3                ) exec i3;;
    kde               ) DESKTOP_SESSION=plasma exec startplasma-x11;;
    xfce              ) exec startxfce4;;
    leftwm            ) exec dbus-launch leftwm;;
    *                 ) exec ${1:-bspwm};;
esac
