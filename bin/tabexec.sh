#!/bin/bash

# when node-add node-remove happened,
# it will insert it in current tabbed container

id=$(bspc query -N -n focused)
if [[ -z $(pgrep -fo "tabbed-sub $id") ]]; then
  # 1. must gui app (like alacritty) will block toggle back,
  #    we can use interactive version (alacritty msg create-window)
  #    another way, because alacritty & never wait:
  #       '&' executes a command in the background, and will return 0 regardless of its status
  #    so we can also use 'alacritty & disown' as long as the app is inserted fast enough...
  # 2. the app launched by rofi should also wait for toggle back
  #       workaround1: insert a sleep...ugly
  #       workaround2: don't use poor launcher, make it by yourlself (https://github.com/davatorium/rofi/issues/1546)
  #       workaround3: dmenu, ~/bin/tabexec.sh eval "$(dmenu_path | rofi -dmenu)"
  tabc autoattach "$id" && eval "$@" && tabc autoattach "$id"
else
  eval "$@"
fi
