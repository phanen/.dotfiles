#!/bin/sh
[[ -z $NVIM ]] && { nvim "$@"; true; } || { nvim -u NONE --server $NVIM --remote-expr "execute(\"ToggleTerm\")" && nvim -u NONE --server $NVIM --remote "$@"; }
