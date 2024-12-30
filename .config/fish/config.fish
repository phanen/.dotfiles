status is-interactive; and begin
    source $__fish_config_dir/abbr.fish
    source $__fish_config_dir/alias.fish

    command -q zoxide; and function __z_hook --on-variable PWD
        test -z "$fish_private_mode"
        and command zoxide add -- (builtin pwd -L)
    end
end
