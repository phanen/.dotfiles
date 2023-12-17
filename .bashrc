# if not running interactively, don't do anything
[[ $- != *i* ]] && return

[[ -f ~/.shellrc ]] && . ~/.shellrc

PS1='[\u@\h \W]\$ '
shopt -s autocd checkwinsize
[[ -f ~/.config/bash/bind.sh ]] && . ~/.config/bash/bind.sh

eval "$(zoxide init bash)"
# eval "$(starship init bash)"
