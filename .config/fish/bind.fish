if test $__fish_initialized -lt 3800
    bind \ce _eol_or_fzf
    bind \c\; "if command -q kitten; exec kitten run-shell; else; exec fish; end"
    bind \cf _forward_or_fzf
    bind \cg '_empty_then "yazi;commandline -f repaint" _fish_lookup'
    bind \ch '_empty_then "__fish_echo tokei" "_autopair_backspace"'
    bind \cj nextd-or-forward-word
    bind \cl '_empty_trim_then "_clean;commandline -f repaint" "commandline -f kill-bigword"'
    bind \co prevd-or-backward-word
    bind \cq '_empty_trim_then "lazygit;commandline -f repaint" fish_clipboard_copy'
    bind \cr atuin_search
    bind \cs '_empty_then "nvim;commandline -f repaint" __fish_man_page'
    bind \ct 'commandline -i -- (fzf_files);commandline -f repaint'
    bind \cu '_empty_then "htop;commandline -f repaint" "commandline -f backward-kill-line"'
    bind \cw '_empty_then "commandline -f repaint;" "commandline -f backward-kill-path-component"'
    # bind \cm 'nvim -- (commandline -t)'

    bind \e\; 'exec fish'
    bind \ei 'tmux a &>/dev/null || tmux &>/dev/null || tmux det'

    bind \eg commandline
    bind \r k_enter
    bind \e\[47\;5u undo
    bind \cx\ce edit_command_buffer
    bind ' ' '_empty_then "nvim;commandline -f repaint;" \'commandline -i " "\';commandline -f expand-abbr'
    return
end

bind ctrl-e _eol_or_fzf
bind ctrl-\; "exec fish"
bind ctrl-f _forward_or_fzf
bind ctrl-g '_empty_then "yazi;commandline -f repaint" _fish_lookup'
bind ctrl-h '_empty_then "__fish_echo tokei" "_autopair_backspace"'
bind ctrl-j nextd-or-forward-word
# TODO: if at the beginning of word, also kill space...
bind ctrl-l '_empty_trim_then "_clean;commandline -f repaint" "commandline -f kill-bigword"'
# bind ctrl-l '_empty_trim_then "_clean;commandline -f repaint" "commandline -f kill-token"'
bind ctrl-o prevd-or-backward-word
bind ctrl-q '_empty_trim_then "lazygit;commandline -f repaint" fish_clipboard_copy'
bind ctrl-r atuin_search
bind ctrl-s '_empty_then "nvim;commandline -f repaint" __fish_man_page'
bind ctrl-t 'commandline -i -- (fzf_files);commandline -f repaint'
bind ctrl-u '_empty_then "htop;commandline -f repaint" "commandline -f backward-kill-line"'
bind ctrl-w '_empty_then "commandline -f repaint;" "commandline -f backward-kill-path-component"'
bind ctrl-m __fish_man_page # but nvim terminal not fully support kkp
bind ctrl-d _bs_or_del

bind alt-\; 'if command -q kitten; exec kitten run-shell; else; exec fish; end'
# bind alt-\; 'exec fish'
bind alt-i 'tmux a &>/dev/null || tmux &>/dev/null || tmux det'

bind alt-g commandline
bind alt-o toggle-commandline

#bind -k nul 'kitten @ action kitty_scrollback_nvim --config custom'
bind enter k_enter
bind ctrl-x,ctrl-e edit_command_buffer
bind space '_empty_then "nvim;commandline -f repaint;" \'commandline -i " "\';commandline -f expand-abbr'

# TODO: ; shouldn't expand-abbr
