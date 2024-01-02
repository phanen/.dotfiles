
[[ -f ~/.config/shell/env.sh ]] && . ~/.config/shell/env.sh

[[ -f ~/.config/kmonad/kmonad-$(hostname).kbd ]] && kmonad ~/.config/kmonad/kmonad-$(hostname).kbd -w 10 &
# use fish as interactive shell only
exec fish
