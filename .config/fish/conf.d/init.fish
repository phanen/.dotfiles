status is-interactive; and begin
    set plugs https://github.com/jorgebucaran/autopair.fish \
        https://github.com/gazorby/fifc

    if test $__fish_initialized -ge 3800; and set -l fish_root ~/b/fish-shell; and test -d $fish_root
        set fish_complete_path \
            $fish_complete_path[1] \
            $fish_root/share/completions \
            $fish_complete_path[2..]
        set fish_function_path \
            $fish_function_path[1] \
            $fish_root/share/functions \
            $fish_function_path[2..]
    end

    source $__fish_config_dir/abbr.fish
    source $__fish_config_dir/alias.fish
    source $__fish_config_dir/bind.fish

    command -q zoxide; and function __z_hook --on-variable PWD
        test -z "$fish_private_mode"
        and command zoxide add -- (builtin pwd -L)
    end
    command -q atuin; and source $__fish_config_dir/atuin.fish

    export FZF_DEFAULT_OPTS="
  --layout=reverse
  --height=45%
  --scroll-off=10
  --multi
  --exact
  --highlight-line
  --bind='alt-;:toggle-preview'
  --bind='ctrl-d:preview-page-down'
  --bind='ctrl-u:preview-page-up'
  --bind='ctrl-q:toggle-all'
  --bind='ctrl-o:execute:xdg-open {}'
  --bind='ctrl-y:execute-silent:echo {} | xclip -sel clipboard'
  --bind='ctrl-alt-y:execute-silent:xclip -sel clipboard {}'
  --bind='ctrl-l:clear-query'
  --prompt='❯ '
  --no-separator
  --info='inline:❮ '
  --marker='✓'
  --pointer=
  --color fg+:,bg+:bright-black,hl+:-1:reverse,hl:-1:reverse
  # TODO: hl+ should support, then we have hl-fg+:-1:reverse, hl-bg+:-1:reverse
  # --color preview-border:-1:reverse
  --cycle
  --info='inline:❮ '
  --preview-window=border-none
  --history=$XDG_DATA_HOME/fzfhistory
"
    set CURRENT_THEME tokyonight-storm
    # set CURRENT_THEME gruvbox-light
    export LS_COLORS=$(vivid generate $CURRENT_THEME)
    export BAT_THEME=
    # export BAT_THEME=$CURRENT_THEME
    export VISUAL="nvim --cmd 'let g:flatten_wait=1'"
end
