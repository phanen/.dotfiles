set -q __loaded_z; and return

# note: avoid override builtin `cd` function (as we need it here)
# use `builtin cd`
#   -> no dirstack support
# use /usr/share/fish/functions/cd.fish
#   -> `alias cd=z` cause recursion
#      workaround: use `function --copy cd` (but `cd` maybe still override before `zoxide init`)
# anyway, never define `alias cd=z` before `zoxide init` (i.e. never define it in our case)
# https://github.com/ajeetdsouza/zoxide/pull/207

function z
    set -l argc (count $argv)
    if test $argc -eq 0
        cd $HOME
    else if test "$argv" = -
        cd -
    else if test $argc -eq 1 -a -d $argv[1]
        cd $argv[1]
    else if test $argc -eq 2 -a $argv[1] = --
        cd -- $argv[2]
    else if true; and set -l result (string replace -r -- $__z_prefix_regex '' $argv[-1]); and test -n $result
        # else if set -l result (string replace -r -- $__z_prefix_regex '' $argv[-1]); and test -n $result
        cd $result
    else
        set -l result (command $__z_db_query --exclude (eval "$__z_pwd") -- $argv)
        and cd $result
    end
end

complete -c z -f -a '(z_complete)'

function z_complete
    # FIXME: variable is not set in complete....
    # set __z_db_iquery zoxide query -i
    # set __z_pwd builtin pwd -L

    # test the behavior of `commandline`:
    #   commandline 'z n e'; commandline -C 2; commandline -C; count (commandline -po);  count (commandline -cpo)

    # all tokens, include the one under cursor
    set -l tokens (builtin commandline -po)
    # cut-at-cursor: exclude the one under cursor
    set -l curr_tokens (builtin commandline -cpo)
    set -l n_args (builtin count $tokens)
    set -l c_args (builtin count $curr_tokens)

    if [ $n_args -le 2 -a $c_args -eq 1 ]
        # <= 2 arguments, fallback to `cd` completions (`alias cd=z` will break it)
        complete -C "cd "(builtin commandline -cp)
    else if [ $n_args -eq $c_args ]; and ! string match -qr -- ^$__z_prefix. "$tokens[-1]"
        # cursor on whitespace, and the previous arguments before doesn't prefix with `$__z_prefix`
        set -l query $tokens[2..-1]
        set -l result (command $__z_db_iquery --exclude (eval "$__z_pwd") -- $query)
        # prefix a z! (to be used by z)
        echo $__z_prefix$result
        builtin commandline -f repaint
    end
end
