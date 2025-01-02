status is-interactive; and begin
    set plugs https://github.com/jorgebucaran/autopair.fish \
        # https://github.com/gazorby/fifc
        $__fish_user_data_dir/plug/fifc

    source $__fish_config_dir/abbr.fish
    source $__fish_config_dir/alias.fish

    command -q zoxide; and function __z_hook --on-variable PWD
        test -z "$fish_private_mode"
        and command zoxide add -- (builtin pwd -L)
    end
    command -q atuin; and source $__fish_config_dir/atuin.fish
end
