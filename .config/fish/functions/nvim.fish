function nvim -d 'nvim wrapper make life easier'
    set -l save_cwd_here $(mktemp)
    SAVE_CWD_HERE=$save_cwd_here command nvim $argv
    set -l new_dir $(cat $save_cwd_here)
    test -n "$new_dir" -a "$new_dir" != "$PWD"
    and cd $new_dir
    rm $save_cwd_here
end
