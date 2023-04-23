run-help() { help "$READLINE_LINE" 2>/dev/null || man "$READLINE_LINE"; }

# WHICH_SHELL=$(ps -o comm= -p $$)
bind '"\eq": "\C-e >/dev/null 2>&1 &"'
bind '"\ew": "\C-asudo \C-e"'
bind '"\ee": "\C-anvim \C-e"'
bind '"\et": "$(compgen -c | fzf)"\C-m'
bind '"\eo": "\C-alfcd\C-m"'

bind -m vi-insert -x '"\eh": run-help'
bind -m emacs -x '"\eh": run-help'
bind '"\eg": "\C-e2>&1 | rg "'
bind '"\ej": "\C-e2>&1 | nvim -"'
bind '"\ek": "\C-e\C-uclear\C-m"'
bind '"\el": "\C-e | bat"'
