run-help() {
    cmd=$(echo $READLINE_LINE | xargs)
    help "$cmd" 2>/dev/null || man "$cmd";
}

# bind -pm vi
bind '"\eq": "\C-e >/dev/null 2>&1 &"'
bind '"\ew": "\C-asudo \C-e"'
bind '"\ee": "\C-anvim \C-e"'
bind '"\et": "$(compgen -c | fzf)"\C-m'
bind '"\eo": "\C-alfcd\C-m"'

bind -m vi-insert -x '"\eh": run-help'
bind -m emacs -x '"\eh": run-help'
bind '"\eg": "\C-e 2>&1 | nvim -"'
bind '"\ej": "\C-e 2>&1 | rg "'
bind -x '"\ek": "clear"'
bind '"\el": "\C-e | bat"'

# stty werase undef
# tty -a | grep werase
# bind '"\C-w": unix-filename-rubout'
