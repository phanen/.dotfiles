. ~/.env
if [ -z "$SSH_TTY" ] && [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ] && [ !  -e /tmp/xorg.boot ]; then
  DISPLAY=:0 kmonad.sh
  touch /tmp/xorg.boot
  startx
fi
exec fish
