run-help() { help "$READLINE_LINE" 2>/dev/null || man "$READLINE_LINE"; }

run-help() { help "$READLINE_LINE" 2>/dev/null || man "$READLINE_LINE"; }

bind '"\eq": "\C-e > /dev/null 2>&1 &"'
bind '"\ew": "\C-asudo \C-e"'
bind '"\ee": "\C-anvim \C-e"'

bind '"\eo":"\C-alfcd \C-e"'
bind '"\et":"$(compgen -c | fzf)"'

bind '"\eg": "2>&1 | rg "'
bind -m vi-insert -x '"\eh": run-help'
bind -m emacs -x '"\eh": run-help'
bind '"\ej": "2>&1 | nvim -"'
bind '"\ek": "\C-e\C-uclear\C-m"'
bind '"\el": "\C-e | bat"'
