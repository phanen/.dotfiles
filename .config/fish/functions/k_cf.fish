function k_cf
    set -l line "$(commandline)"
    if test -z "$(string trim -- $line)"
        #_ZO_FZF_OPTS=$FZF_DEFAULT_OPTS zoxide query -i
        # TODO: wrap command bug fix is unreleased now...
        #set cmd1 command fd . -d 1 --type d
        #set cmd2 command zoxide query -l

        set cmd1 fd . -d 1 --type d
        set cmd2 zoxide query -l

        set cmd $cmd1
        set cmd $cmd2

        set fzf fzf \
            --bind "ctrl-d:reload(zoxide remove {};$cmd1;$cmd2)" \
            --bind "ctrl-g:reload([[ -f /tmp/fish_k_cf ]] && { $cmd1; rm /tmp/fish_k_cf; true; } || { $cmd2; touch /tmp/fish_k_cf; })"

        set -l res (begin $cmd1; $cmd2; end | $fzf)
        if test -n "$res"
            cd $res
        end
        commandline -f repaint
    else
        commandline -f forward-char
    end
end
