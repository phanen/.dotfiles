#!/bin/sh
command -v xdotool >/dev/null 2>&1 || exit
# w=$(echo "0.985 * $(xrandr | awk '/\*/ {print $1}' | cut -d 'x' -f1) / 1" | bc)
# h=$(echo "0.95 * $(xrandr | awk '/\*/ {print $1}' | cut -d 'x' -f2) / 1" | bc)
# c=$(echo "0.002 * $(xrandr | awk '/\*/ {print $1}' | cut -d 'x' -f1) / 1" | bc)
# r=$(echo "0.002 * $(xrandr | awk '/\*/ {print $1}' | cut -d 'x' -f2) / 1" | bc)

mkdir -p /tmp/scratchpad/
if [ -f /tmp/scratchpad/w ]; then
  w=$(cat /tmp/scratchpad/w)
else
  echo "0.985 * $(xrandr | awk '/\*/ {print $1}' | cut -d 'x' -f1) / 1" | bc >/tmp/scratchpad/w
fi
if [ -f /tmp/scratchpad/h ]; then
  h=$(cat /tmp/scratchpad/h)
else
  echo "0.985 * $(xrandr | awk '/\*/ {print $1}' | cut -d 'x' -f1) / 1" | bc >/tmp/scratchpad/h
fi
if [ -f /tmp/scratchpad/c ]; then
  c=$(cat /tmp/scratchpad/c)
else
  echo "0.985 * $(xrandr | awk '/\*/ {print $1}' | cut -d 'x' -f1) / 1" | bc >/tmp/scratchpad/c
fi
if [ -f /tmp/scratchpad/r ]; then
  r=$(cat /tmp/scratchpad/r)
else
  echo "0.985 * $(xrandr | awk '/\*/ {print $1}' | cut -d 'x' -f1) / 1" | bc >/tmp/scratchpad/r
fi

wid="$(xdotool search --class tdrop_kitty)"

if [ -n "$wid" ]; then
  bspc node "$wid" -g hidden -f
else
  bspc rule -a '*' -o state=floating rectangle="$w"x"$h"+"$c"+"$r" && kitty --class "tdrop_kitty"
fi
