#!/bin/bash

# $(xprop -id $(xdotool getactivewindow) | rg WM_CLASS | cut -d '"' -f2)
if [ "$(xdotool getactivewindow getwindowclassname)" = *kitty* ]; then
  kitty @ close-tab
else
  bspc node -c
fi
