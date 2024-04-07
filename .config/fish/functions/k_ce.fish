function k_ce
    set -l line (commandline)
    if test -z "$(string trim -- $line)"
        # TODO: _fzf_search_directory
        # set -l ent (fd . -d 1 -I -H | fzf)
        set -l ent (fd . -H | fzf)
        if test -n "$ent"
            if test -d "$ent"
                __zoxide_z "$ent"
            else if test -f "$ent"
                nvim "$ent"
            end
        end
        commandline -f repaint
    else
        commandline -f end-of-line
    end
end
