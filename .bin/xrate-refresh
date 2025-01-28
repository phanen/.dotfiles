#!/usr/bin/env bash

# https://unix.stackexchange.com/questions/121858/how-can-i-set-repeat-rate-of-usb-keyboard-with-udev
(
  set -e
  PID=$(pgrep bspwm | head -1)
  eval "$(sed 's:\x0:\n:g' /proc/$PID/environ | rg 'DISPLAY=' | head -1)"
  # TODO: use udev rule local to user?
  eval "$(sed 's:\x0:\n:g' /proc/$PID/environ | rg 'USER=' | head -1)"
  XAUTHORITY="/home/$USER/.Xauthority"
  DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY xset r rate 140 100
) &
