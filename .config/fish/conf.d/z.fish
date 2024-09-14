# database backend (external binary)
# note: set -l cannot access by function
if not command -q zoxide
    echo 'no back end'
    return
end

function __z_pwd
    builtin pwd -L
end

function __z_db_add
    command zoxide add $argv
end

# fish_indent: ignore end
function __z_hook --on-variable PWD
    # echo pwd $argv
    test -z "$fish_private_mode"
    and __z_db_add -- (__z_pwd)
end
