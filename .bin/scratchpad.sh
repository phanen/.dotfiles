#!/bin/sh
w=$(echo "0.985 * $(xrandr | awk '/\*/ {print $1}' | cut -d 'x' -f1) / 1" | bc)
h=$(echo "0.95 * $(xrandr | awk '/\*/ {print $1}' | cut -d 'x' -f2) / 1" | bc)
c=$(echo "0.002 * $(xrandr | awk '/\*/ {print $1}' | cut -d 'x' -f1) / 1" | bc)
r=$(echo "0.002 * $(xrandr | awk '/\*/ {print $1}' | cut -d 'x' -f2) / 1" | bc)
wid="$(xdotool search --class tdrop_kitty)"

if [ -n "$wid" ]; then
  bspc node "$wid" -g hidden -f
else
  bspc rule -a '*' -o state=floating rectangle="$w"x"$h"+"$c"+"$r" && kitty --class "tdrop_kitty"
fi
