function _forward_or_fzf
    # not know why, but $line has been trimed (no trailing linebreak...)
    set -l line "$(commandline)"
    set -l buf_cur_idx (commandline -C) # utf-8 index
    set -l line_str_len (string length -- "$line")

    # commandline is not empty
    if test "$line_str_len" -ne "$buf_cur_idx" || test -n "$line"
        commandline -f forward-char
        return
    end

    # || test $buf_cur_idx -ne 0
    set -l ent (_fzf_dirs)
    if test -d "$ent"
        cd $ent
    end
end
