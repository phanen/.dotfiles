bind ctrl-i _fifc
bind ctrl-e _eol_or_fzf
bind ctrl-\; "exec fish"
bind ctrl-f _forward_or_fzf
bind ctrl-g '_empty_then "yazi;commandline -f repaint" _fish_lookup'
bind ctrl-h '_empty_then "__fish_echo tokei" "_autopair_backspace"'
bind ctrl-j nextd-or-forward-word
# TODO: if at the beginning of word, also kill space...
bind ctrl-l '_empty_trim_then "_clean;commandline -f repaint" "commandline -f kill-bigword"'
bind ctrl-o prevd-or-backward-word
bind ctrl-q '_empty_trim_then "lazygit;commandline -f repaint" fish_clipboard_copy'
bind ctrl-r atuin_search
bind ctrl-s '_empty_then nvim __fish_man_page'
bind ctrl-t 'commandline -i -- (_fzf_files)'
bind ctrl-u '_empty_then "htop;commandline -f repaint" "commandline -f backward-kill-line"'
bind ctrl-w '_empty_then "__fish_echo eza -lh --hyperlink" "commandline -f backward-kill-path-component"'
bind ctrl-m 'nvim -- (commandline -t)'

bind alt-\; 'exec fish'
bind alt-i 'tmux a &>/dev/null || tmux &>/dev/null || tmux det'
bind alt-l clear-screen
bind alt-w 'fish_key_reader -c'

bind alt-g commandline

#bind -k nul 'kitten @ action kitty_scrollback_nvim --config custom'
bind enter k_enter
