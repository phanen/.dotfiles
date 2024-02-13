. ~/.env
if [ -z "$SSH_TTY" ]; then
  DISPLAY=:0 kmonad.sh
  if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ] && [ !  -e /tmp/xorg.boot ]; then
    touch /tmp/xorg.boot
    startx
  fi
fi
exec fish
