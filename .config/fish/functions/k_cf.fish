function k_cf
    set -l line "$(commandline)"
    if test -z "$(string trim -- $line)"
        #_ZO_FZF_OPTS=$FZF_DEFAULT_OPTS zoxide query -i
        set -l res (begin zoxide query -l; fd . -d 1 --type d; end | fzf)
        if test -n "$res"
            cd $res
        end
        commandline -f repaint
    else
        commandline -f forward-char
    end
end
