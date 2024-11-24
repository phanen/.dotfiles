command -q zoxide; or return

function __z_hook --on-variable PWD
    test -z "$fish_private_mode"
    and command zoxide add -- (builtin pwd -L)
end
