if set -q FISH_LATEST
    bind ctrl-e k_ce
    bind ctrl-\\ "exec fish"
    bind ctrl-f k_cf
    bind ctrl-g k_cg
    bind ctrl-h '_empty_then "echo;tokei;commandline -f repaint" "_autopair_backspace"'
    bind ctrl-i _fifc
    bind ctrl-j nextd-or-forward-word
    # TODO: if at the beginning of word, also kill space...
    bind ctrl-l '_empty_trim_then "cl;commandline -f repaint" "commandline -f kill-bigword"'
    bind ctrl-o prevd-or-backward-word
    bind ctrl-q '_empty_trim_then "lazygit;commandline -f repaint" fish_clipboard_copy'
    bind ctrl-r atuin_search
    bind ctrl-s k_cs
    bind ctrl-t k_ct
    bind ctrl-u '_empty_then "htop;commandline -f repaint" "commandline -f backward-kill-line"'
    bind ctrl-w '_empty_then "echo;ls;commandline -f repaint" "commandline -f backward-kill-path-component"'

    bind alt-\; 'exec fish'
    bind alt-i 'tmux a &>/dev/null || tmux &>/dev/null || tmux det'
    bind alt-l clear-screen
    bind alt-w 'fish_key_reader -c'

    #bind -k nul 'kitten @ action kitty_scrollback_nvim --config custom'
    bind enter k_enter
    bind tab _fifc
else
    # deprecating
    bind \ce k_ce
    bind \cf k_cf
    bind \cg k_cg
    bind \ch '_empty_then "echo;tokei;commandline -f repaint" "_autopair_backspace"'
    bind \cj nextd-or-forward-word
    bind \cl '_empty_trim_then "cl;commandline -f repaint" "commandline -f kill-bigword"'
    bind \co prevd-or-backward-word
    bind \cq '_empty_trim_then "lazygit;commandline -f repaint" fish_clipboard_copy'
    bind \cr atuin_search
    bind \cs k_cs
    bind \ct k_ct
    bind \cu '_empty_then "htop;commandline -f repaint" "commandline -f backward-kill-line"'
    bind \cw '_empty_then "echo;ls;commandline -f repaint" "commandline -f backward-kill-path-component"'

    bind \e\[47\;5u undo
    bind \e\; 'htop;commandline -f repaint'
    bind \ei 'tmux a &>/dev/null || tmux &>/dev/null || tmux det'
    bind \el clear-screen
    bind \ew 'fish_key_reader -c'

    bind \r k_enter
    bind \t _fifc
    bind \x1c "exec fish"
end
