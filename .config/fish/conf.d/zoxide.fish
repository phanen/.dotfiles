status is-interactive; or return

if ! builtin functions --query __zoxide_cd_internal
    if builtin functions --query cd
        builtin functions --copy cd __zoxide_cd_internal
    else
        alias __zoxide_cd_internal='builtin cd'
    end
end

function __zoxide_hook --on-variable PWD
    test -z "$fish_private_mode"
    and command zoxide add -- (__zoxide_pwd)
end

if test -z $__zoxide_z_prefix
    set __zoxide_z_prefix 'z!'
end

set __zoxide_z_prefix_regex ^(string escape --style=regex $__zoxide_z_prefix)
