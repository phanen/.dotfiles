# if status is-interactive

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
bind \cy fish_clipboard_copy

# fzf, https://github.com/gazorby/dotfiles/tree/19916f70981658aa5d59a154b21fab3faed28cf4
# fifc -f --bind='space:accept,;:abort'
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

    # if type -q fzf_configure_bindings
    #     fzf_configure_bindings --directory=\cf --processes=\cp --git_log=\cg --history=\cr
    # end
    #
    # # Use exa to list files (with colors) if present
    # if type -q exa
    #     set -gx fzf_preview_dir_cmd exa --all --color=always
    # end
    #
    # set -gx fzf_fd_opts --follow
    # # Bind ctrl+h to reload with hidden files
    # set -a fzf_dir_opts --bind='ctrl-h:reload(fd --type file --color=always --hidden --follow --exclude .git)'
    # # Bind ctrl+x to reload with executable files
    # set -a fzf_dir_opts --bind='ctrl-x:reload(fd --type executable --color=always --hidden --follow --exclude .git)'
    # # Bind ctrl+d to reload with directories only
    # set -a fzf_dir_opts --bind='ctrl-d:reload(fd --type directory --color=always --hidden --follow --exclude .git)'
    # # Bind ctrl+f to reload with the default search options
    # set -a fzf_dir_opts --bind='ctrl-f:reload(fd --type file --color=always --follow)'
    # # Bind ctrl+o to open the current item
    # set -a fzf_dir_opts --bind="ctrl-o:execute(nvim {} &> /dev/tty)"
    #
    # set -gx fzf_preview_file_cmd fzf_file_preview
    #
    # # Use bat to preview files if present
    # if not type -q bat
    #     set -gx fzf_preview_file_cmd cat
    # end
    # # find -L . \( -path ./.git -prune -path ./node_modules -prune \) -o -print -type f 2> /dev/null
    # # Use delta to show git diff when searching through git log
    # if type -q delta
    #     set -gx fzf_git_log_opts --preview='git show {1} | delta'
    # end
    #
    # # Forgit plugin
    # set -U forgit_log glo:
    # set -U forgit_diff gd:
    # set -U forgit_add ga:
    # set -U forgit_reset_head grh:
    # set -U forgit_ignore gif
    # set -U forgit_restore gcf:
    # set -U forgit_clean gclean:
    # set -U forgit_stash_show gss:
    # set -U forgit_cherry_pick gcp:
    # set -U forgit_rebase grb:
end

# fish_key_reader

bind \co prevd-or-backward-word
bind \x1c nextd-or-forward-word

bind \ef vifm
bind \cq lazygit
bind \eg lazygit

bind \ej '\ca\ce 2>&1|rg'
bind \ek clear
bind \el '\ca\ce 2>&1|bat'
bind \eq '\ca\ce >/dev/null 2>&1&'
bind \en nvim


# stty werase undef
# tty -a | grep werase
# bind '"\C-w": unix-filename-rubout'

set -Ux fifc_editor nvim
set -U fifc_keybinding \t
zoxide init fish | source
# source (/usr/bin/starship init fish --print-full-init | psub)
# /usr/bin/starship init fish --print-full-init | source
# end
