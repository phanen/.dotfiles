#!/bin/sh

# ??: local?
LASTHIDDEN="$(bspc query -N -n .hidden | tail -n1)"
[[ -z $LASTHIDDEN ]] && (bspc node -g hidden) \
  || (bspc node $LASTHIDDEN -g hidden=off; bspc node -f $LASTHIDDEN)

