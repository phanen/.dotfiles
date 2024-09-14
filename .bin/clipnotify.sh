#!/bin/sh
# used by cliphist.service

while clipnotify; do
  # TODO: binary support
  # https://github.com/sentriz/cliphist/blob/master/contrib/cliphist-rofi-img
  # xclip -o --target TARGETS #| grep -q image && xclip -o -t image/png -o > /tmp/clipnotify.png
  xclip -o -sel c | cliphist store
done
