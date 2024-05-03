#!/bin/sh

toggle_touchpad() {
  # for chromebook c1030
  TOUCHPAD_IS_ENABLE=$(xinput list-props 'Elan Touchpad' | rg 'Device Enable' | awk '{print $NF}')
  if [ "$TOUCHPAD_IS_ENABLE" = 1 ]; then
    xinput disable 'Elan Touchpad'
    notify-send "Touchpad disabled"
  else
    xinput enable 'Elan Touchpad'
    notify-send "Touchpad enabled"
  fi
}

toggle_ffmpeg() {
  if [ -z $(pgrep ffmpeg) ]; then
    ffmpeg -y -f x11grab -i "$DISPLAY" -framerate 25 -c:v libx264 ~/test-"$(date -u +%Y-%m-%dT%H:%M:%S%Z)".mp4 &
    notify-send "ffmpeg is started"
    polybar-msg hook ffmpeg-recording 1
  else
    pkill ffmpeg
    notify-send "ffmpeg is killed"
    polybar-msg hook ffmpeg-recording 2
  fi
}

toggle_polybar() {
  if [ -f /tmp/polybarhidden ]; then
    polybar-msg cmd show
    bspc config bottom_padding 23
    rm /tmp/polybarhidden
  else
    polybar-msg cmd hide
    bspc config bottom_padding 0
    touch /tmp/polybarhidden
  fi
}

case $1 in
touchpad)
  toggle_touchpad
  ;;
video)
  toggle_ffmpeg
  ;;
polybar)
  toggle_polybar
  ;;
*)
  printf "Usage: %s touchpad|video|polybar\n" "$0"
  exit 1
  ;;
esac
