bind \ce k_ce
bind \cf k_cf
bind \cg k_cg
bind \ch '_empty_then "echo;tokei;commandline -f repaint" "_autopair_backspace"'
bind \cj nextd-or-forward-word
bind \cl '_empty_trim_then "cl;commandline -f repaint" "commandline -f kill-bigword"'
bind \co prevd-or-backward-word
bind \cq '_empty_trim_then "lazygit;commandline -f repaint" fish_clipboard_copy'
bind \cs k_cs
bind \ct k_ct
bind \cu '_empty_then "htop;commandline -f repaint" "commandline -f backward-kill-line"'
bind \cw '_empty_then "echo;ls;commandline -f repaint" "commandline -f backward-kill-path-component"'
bind \e\[47\;5u undo
bind \e\; 'htop;commandline -f repaint'
bind \ei 'tmux a &>/dev/null || tmux &>/dev/null || tmux det'
bind \el clear-screen
bind \er 'exec fish'
bind \ew 'fish_key_reader -c'
#bind -k nul 'kitten @ action kitty_scrollback_nvim --config custom'
bind \r k_enter
bind \t _fifc
bind \x1c "exec fish"

bind \cr _atuin_search
# TODO: so what is _bind_up
#bind -k up _atuin_bind_up
#bind \eOA _atuin_bind_up
#bind \e\[A _atuin_bind_up
