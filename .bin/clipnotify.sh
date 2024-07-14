#!/bin/sh
while clipnotify; do
  # TODO: binary support
  # https://github.com/sentriz/cliphist/blob/master/contrib/cliphist-rofi-img
  xclip -o -sel c | cliphist store
done
