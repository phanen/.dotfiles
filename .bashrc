# if not running interactively, don't do anything
[[ $- != *i* ]] && return

. ~/.shellrc

PS1='[\u@\h \W]\$ '
shopt -s autocd checkwinsize

run-help() {
  cmd=$(echo $READLINE_LINE | xargs)
  help "$cmd" 2>/dev/null || man "$cmd"
}

bind '"\eq": "\C-e >/dev/null 2>&1 &"'
bind '"\es": "\C-asudo \C-e"'
bind -m vi-insert -x '"\eh": run-help'
bind -m emacs -x '"\eh": run-help'
bind '"\ej": "\C-e 2>&1 | rg "'
bind -x '"\ek": "clear"'
bind '"\el": "\C-e | bat"'

eval "$(zoxide init bash)"
eval "$(atuin init bash)"
stty stop undef
