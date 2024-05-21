function __zoxide_z
    set -l argc (count $argv)
    if test $argc -eq 0
        cd $HOME
    else if test "$argv" = -
        cd -
    else if test $argc -eq 1 -a -d $argv[1]
        cd $argv[1]
    else if set -l result (string replace --regex $__zoxide_z_prefix_regex '' $argv[-1]); and test -n $result
        cd $result
    else
        set -l result (command zoxide query --exclude (builtin pwd -L) -- $argv)
        and cd $result
    end
end
