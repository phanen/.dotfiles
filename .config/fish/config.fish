if status is-interactive

end

abbr -a c cargo
abbr -a e nvim
abbr -a o xdg-open
abbr -a --position anywhere ppp https_proxy=127.0.0.1:7890 http_proxy=127.0.0.1:7890 all_proxy=127.0.0.1:7890

set -U fish_greeting
# set fish_greeting ""

cat ~/.bashrc | sed "/\$-/d;" | babelfish | source
# WIP
# cat ~/.config/bash/keybindings.sh | sed "/\$-/d;" | babelfish | source

# fcitx5 env, should export here, anyway...
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export SDL_IM_MODULE=fcitx
export GLFW_IM_MODULE=ibus

fish_default_key_bindings

bind --preset H beginning-of-line
bind --preset L end-of-line
bind --preset -M visual H beginning-of-line
bind --preset -M visual L end-of-line
bind --preset -M visual -m default v end-selection repaint-mode

# fzf, https://github.com/gazorby/dotfiles/tree/19916f70981658aa5d59a154b21fab3faed28cf4
if type -q fzf
    set -Ux FZF_DEFAULT_OPTS "
        --layout=reverse
        --height=90%
        --prompt='~ ' --pointer='▶' --marker='✓'
        --multi
        --bind='space:accept'
        --bind=';:abort'
        --bind='?:toggle-preview'
        --color='hl:148,hl+:154,pointer:032,marker:010,bg+:237,gutter:008'
    "

    # fzf_configure_bindings --directory=\cf --processes=\cp --git_log=\cg --history=\cr

    set -Ux fifc_editor nvim
    set -U fifc_keybinding \ci
end

bind \ew fish_key_reader
bind \cy fish_clipboard_copy
# PERF: since nvim cannot restart now
bind \cs nvim
bind \cg lazygit
bind \x1c htop
bind \co prevd-or-backward-word
bind \cj nextd-or-forward-word

zoxide init fish | source
# /usr/bin/starship init fish --print-full-init | source
