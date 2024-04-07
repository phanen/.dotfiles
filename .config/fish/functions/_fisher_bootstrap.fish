function _fisher_bootstrap
    read -ln1 -P"$(set_color blue)Install plugins$(set_color green) (Y/n)" -- y_or_n
    test -z "$(string trim -- $y_or_n)" -o "$(string lower -- $y_or_n)" = n; and return

    set -l t (mktemp)
    cp $__fish_config_dir/fish_plugins $t
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
    and fisher update
    mv $t $__fish_config_dir/fish_plugins

    set -U fish_greeting
    exec fish
end
