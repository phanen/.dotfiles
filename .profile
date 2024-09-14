#!/bin/sh

. ~/.environ

case $0 in
-*)
  if [ -z "$SSH_TTY" ] && [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ] && [ ! -e /tmp/xorg.boot ]; then
    : >/tmp/xorg.boot
    exec startx
  fi
  ;;
*) ;;
esac

case $(tty) in
*tty*) setfont ter-d28b ;;
*) ;;
esac

# for ssh login

# use fish as interactive shell only (not default shell)
exec fish
