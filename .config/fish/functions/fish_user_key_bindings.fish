# since many plugins will hijack bindings, we can always override them in here
# TODO(ctrl-enter): https://superuser.com/questions/1056536/ctrl-enter-for-fish-shell

bind ctrl-i _fifc
bind ctrl-e k_ce
bind ctrl-\; "exec fish"
bind ctrl-f k_cf
bind ctrl-g k_cg
bind ctrl-h '_empty_then "echo;tokei;commandline -f repaint" "_autopair_backspace"'
bind ctrl-j nextd-or-forward-word
# TODO: if at the beginning of word, also kill space...
bind ctrl-l '_empty_trim_then "_clean;commandline -f repaint" "commandline -f kill-bigword"'
bind ctrl-o prevd-or-backward-word
bind ctrl-q '_empty_trim_then "lazygit;commandline -f repaint" fish_clipboard_copy'
bind ctrl-r atuin_search
bind ctrl-s k_cs
bind ctrl-t k_ct
bind ctrl-u '_empty_then "htop;commandline -f repaint" "commandline -f backward-kill-line"'
bind ctrl-w '_empty_then "echo;eza -lh;commandline -f repaint" "commandline -f backward-kill-path-component"'

bind alt-\; 'exec fish'
bind alt-i 'tmux a &>/dev/null || tmux &>/dev/null || tmux det'
bind alt-l clear-screen
bind alt-w 'fish_key_reader -c'

bind alt-g commandline

#bind -k nul 'kitten @ action kitty_scrollback_nvim --config custom'
bind enter k_enter
