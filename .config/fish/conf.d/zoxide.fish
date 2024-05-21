status is-interactive; or return

# generated from zoxide init, but remove useless indirect
function __zoxide_hook --on-variable PWD
    test -z "$fish_private_mode"
    and command zoxide add -- (__zoxide_pwd)
end

if test -z $__zoxide_z_prefix
    set __zoxide_z_prefix 'f!'
end

set __zoxide_z_prefix_regex ^(string escape --style=regex $__zoxide_z_prefix)
