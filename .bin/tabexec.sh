#!/usr/bin/env bash

# any node is not in containers by default
# this script first wrap current node into container
# then insert new node in current container
# (if current node has been in container, just insert directly)


# [[ "$(tabc printclass "$id")" == "tabbed" ]] ||

# 'tabc create' is hacked to create non-autoattach
tabc create "$(bspc query -N -n focused)"

id=$(bspc query -N -n focused)

if [[ -z $(pgrep -fo "tabbed-sub $id") ]]; then
  # 1. most gui app (like alacritty) will block toggle back,
  #    we can use interactive version (alacritty msg create-window)
  #    another way, because alacritty & never wait:
  #       '&' executes a command in the background, and will return 0 regardless of its status
  #    so we can also use 'alacritty & disown' as long as the app is inserted fast enough...
  # 2. the app launched by rofi should also wait for toggle back
  #       workaround1: insert a sleep...ugly
  #       workaround2: don't use poor launcher, make it by yourlself (https://github.com/davatorium/rofi/issues/1546)
  #       workaround3: dmenu, ~/bin/tabexec.sh eval "$(dmenu_path | rofi -dmenu)"
  # TODO: don't work
  tabc autoattach "$id" && eval "$@" && tabc autoattach "$id"
  # tabc autoattach "$id"
  # sleep .1
  # exec "$@"
  # tabc autoattach "$id"
else # should not happend, but we handle it
  eval "$@" && tabc autoattach "$id"
fi
