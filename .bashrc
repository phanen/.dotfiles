# if not running interactively, don't do anything
[[ $- != *i* ]] && return

. ~/.shellrc

PS1='[\u@\h \W]\$ '

# remove all but the last identical command, and commands that start with a space
export HISTCONTROL="erasedups:ignorespace"

# autocd accept expansion e.g. `*` (seems dangerous)
shopt -s autocd checkwinsize

run-help() {
  cmd=$(echo $READLINE_LINE | xargs)
  help "$cmd" 2>/dev/null || man "$cmd"
}

# bind '"\eq": "\C-e >/dev/null 2>&1 &"'
# bind '"\es": "\C-asudo \C-e"'
# bind -m vi-insert -x '"\eh": run-help'
# bind -m emacs -x '"\eh": run-help'
# bind '"\ej": "\C-e 2>&1 | rg "'
# bind -x '"\ek": "clear"'
# bind '"\el": "\C-e | bat"'

eval "$(zoxide init bash)"
eval "$(atuin init bash)"
stty stop undef

# . /usr/share/fzf/key-bindings.bash
if ! [ -f ~/.local/share/blesh/ble.sh ]; then
  . ~/.local/share/blesh/ble.sh
  ble-import -d integration/fzf-completion
  ble-import -d integration/fzf-key-bindings
  ble-import contrib/prompt-git
  bleopt prompt_rps1='\q{contrib/git-info}'
fi

#
# _ble_contrib_fzf_git_config=key-binding:sabbrev:arpeggio
# ble-import -d integration/fzf-git
