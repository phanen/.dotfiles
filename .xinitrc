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

# setxkbmap -option caps:escape
# setxkbmap -option altwin:swap_alt_win

# exec chromium

# _bootstrap() { if ! pgrep "$1"; then eval "$@" 2>&1 >/dev/null; fi }
kmonad ~/.config/kmonad/kmonad.kbd -w 10 & disown
sxhkd -a Tab &
polybar -r &
fcitx5 -d &
picom &

# udiskie &

session=${1:-bspwm}
case $session in
    bspwm             ) exec bspwm;;
    dwm               ) exec dwm;;
    awesome            ) exec awesome;;
    kde               ) exec startplasma-x11;;
    xfce|xfce4        ) exec startxfce4;;
    *                 ) exec $1;;
esac
