function clashz --wrap clash
  pkill -x clash
  set -l CLASH_CONFIG (fd ".*\.yaml"  ~/.config/clash --type f  | fzf -1 --preview 'bat --color=always {}')
  test -f $CLASH_CONFIG; or return
  # https://github.com/kovidgoyal/kitty/issues/307
  command clash -f $CLASH_CONFIG &>/dev/null & disown
end
