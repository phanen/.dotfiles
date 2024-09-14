function k_ce
    set -l line (commandline)
    if test -z "$(string trim -- $line)"
        # TODO: _fzf_search_directory
        set -l delimiter \xe2\x80\x82

        set -l src fd
        set -l src_noignore fd -d 1 -I -H
        set src_noignore (string escape -- $src_noignore)

        set -l fzf fzf \
            --ansi \
            --delimiter $delimiter \
            --nth=2 \
            --bind "ctrl-g:reload($src_noignore)"

        # set -l ent ($src | ifd.sh | $fzf | string split -f 2 $delimiter)
        set -l ent ($src | file_web_devicon | $fzf | string split -f 2 $delimiter)

        if test -n "$ent"
            if test -d "$ent"
                z "$ent"
            else if test -f "$ent"
                nvim "$ent"
            end
        end
        commandline -f repaint
    else
        commandline -f end-of-line
    end
end
