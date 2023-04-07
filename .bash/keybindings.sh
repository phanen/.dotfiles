
## key bindings
bind '"\C-o":"\C-alfcd \C-e"'
bind '"\C-t":"$(compgen -c | fzf)"'
bind '"\C-v": "\C-avi \C-e"'
bind '"\es": "\C-asudo \C-e"'
bind '"\e\C-b": "\C-e > /dev/null 2>&1 &"'
bind '"\e\C-l": "\C-e | less"'
run-help() { help "$READLINE_LINE" 2>/dev/null || man "$READLINE_LINE"; }
bind -m vi-insert -x '"\eh": run-help'
bind -m emacs -x     '"\eh": run-help'

bind '"\C-l": "\C-e\C-uclear\C-m"'
