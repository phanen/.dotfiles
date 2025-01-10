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
end
