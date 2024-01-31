#!/bin/sh
CONFIG="$(find ~/.config/*/init.lua -prune -exec sh -c 'basename $(dirname {})' \;)"
SELECTED=$(printf "%s\n" "${CONFIG[@]}" | fzf --prompt="Neovim Config >>" --height=~50% --layout=reverse --border --exit-0)
if [[ -z $SELECTED ]]; then
  echo "Nothing selected"
  return 0
fi
NVIM_APPNAME=$SELECTED nvim $@
