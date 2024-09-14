# anyway, never define `alias cd=z` before `zoxide init` (i.e. never define it in our case)
# https://github.com/ajeetdsouza/zoxide/pull/207

function __z_db_query
    command zoxide query --exclude (__z_pwd) $argv
end

function __z_db_iquery
    command zoxide query -i --exclude (__z_pwd) $argv
end

# about `cd` provider (a robust `cd` for internal usage):
#   native cd (function)               -> bad, `alias cd=z` cause recursion (fish `alias` is just function)
#   builtin cd                         -> fine, but no dirstack support
#   function --copy cd                 -> bad, `alias cd=z` may happend before `zoxide init`
#   $__fish_data_dir/functions/cd.fish -> ok, just ok anywhere
string replace --regex -- '^function cd\s' 'function __z_cd ' <$__fish_data_dir/functions/cd.fish | source

function z
    set -l argc (count $argv)
    if test $argc -eq 0
        __z_cd $HOME
    else if test "$argv" = -
        __z_cd -
    else if test $argc -eq 1 -a -d $argv[1] # z <dir>
        __z_cd $argv[1]
    else if test $argc -eq 2 -a $argv[1] = -- # z -- <whatever>
        __z_cd -- $argv[2]
    else # z <query>
        set -l result (__z_db_query -- $argv)
        and __z_cd $result
    end
end

function __z_complete
    # test the behavior of `commandline`:
    #   commandline 'z n e'; commandline -C 2; commandline -C; count (commandline -po);  count (commandline -cpo)
    # all tokens, include the one under cursor
    set -l tokens (builtin commandline -po)
    # cut-at-cursor: exclude the one under cursor
    set -l curr_tokens (builtin commandline -cpo)
    set -l n_args (builtin count $tokens)
    set -l c_args (builtin count $curr_tokens)

    if [ $n_args -le 2 -a $c_args -eq 1 ]
        # don't use complete for cd, otherwise `alias cd=z` won't work
        complete -C "'' "(builtin commandline -cp) | string match --regex -- '.*/$'
    else if [ $n_args -eq $c_args ]; and ! string match -qr -- ^$__z_prefix. "$tokens[-1]"
        # If the last argument is empty, use interactive selection.
        set -l query $tokens[2..-1]
        set -l result (__z_db_iquery)
        and z $result
        and builtin commandline -f repaint cancel-commandline
        # # cursor on whitespace, and the previous arguments before doesn't prefix with `$__z_prefix`
        # set -l result (__z_db_iquery -- $query)
        # # prefix a z! (to be used by z)
        # echo $__z_prefix$result
    end
end

complete -c z -f -a '(__z_complete)'
