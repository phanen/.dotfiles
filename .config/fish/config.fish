source ~/.config/fish/sh-common.fish

abbr -a c cargo
abbr -a g git
abbr -a o xdg-open
abbr -a ta tmux a || tmux
abbr -a --position anywhere ppp https_proxy=127.0.0.1:7890 http_proxy=127.0.0.1:7890 all_proxy=127.0.0.1:7890

# fish_default_key_bindings

# fzf, https://github.com/gazorby/dotfiles/tree/19916f70981658aa5d59a154b21fab3faed28cf4
if type -q fzf
    set -Ux FZF_DEFAULT_OPTS "
        --layout=reverse
        --height=90%
        --prompt='~ ' --pointer='▶' --marker='✓'
        --multi
        --bind=';:abort'
        --bind='?:toggle-preview'
        --color='hl:148,hl+:154,pointer:032,marker:010,bg+:237,gutter:008'
    "
    # --bind='space:accept'

    # fzf_configure_bindings --directory=\cf --processes=\cp --git_log=\cg --history=\cr

    set -Ux fifc_editor nvim
    set -U fifc_keybinding \ci
end

bind \ew fish_key_reader
bind \cq fish_clipboard_copy
# PERF: since nvim cannot restart now
bind \cs nvim
bind \cg lazygit
bind \x1c htop
bind \co prevd-or-backward-word
bind \cj nextd-or-forward-word
bind \cl __fish_list_current_token
bind \el clear
bind \ei 'tmux a 2>1 >/dev/null || tmux 2>1 >/dev/null || tmux det'
bind \er 'sh2fish.sh && rs'
bind \cd delete-or-exit

set -U fish_greeting
zoxide init fish | source
# /usr/bin/starship init fish --print-full-init | source

# if status is-login && test -z "$TMUX" && test -n "$SSH_TTY"
#     exec sh -c 'tmux a || tmux'
# end
