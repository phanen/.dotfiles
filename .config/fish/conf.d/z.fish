status is-interactive; or return
set -q __loaded_z; and return

# database backend (external binary)
# note: set -l cannot access by function
if command -q zoxide
    # try variable-as-command: https://github.com/fish-shell/fish-shell/pull/10249
    # the problem: variable is only expanded once, so the following is impossible...
    # set __z_db_query zoxide query --exclude (pwd)
    # set __z_db_query zoxide query --exclude "($__z_pwd)"
    # set __z_db_query zoxide query --exclude "(eval \"$__z_pwd\")"
    set __z_db_add zoxide add
    set __z_db_query zoxide query
    set __z_db_iquery zoxide query -i
else
    echo 'no back end'
end

set __z_pwd builtin pwd -L
set __z_prefix 'z!'

function __z_hook --on-variable PWD
    test -z "$fish_private_mode"
    and command $__z_db_add -- (eval $__z_pwd)
end
