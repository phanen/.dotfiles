
[[ -f ~/.config/shell/env.sh ]] && . ~/.config/shell/env.sh

kmonad ~/.config/kmonad/kmonad-$(hostname).kbd -w 10 &
# use fish as interactive shell only
exec fish
