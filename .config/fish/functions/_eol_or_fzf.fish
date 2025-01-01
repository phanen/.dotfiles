function _eol_or_fzf
    # not know why, but $line has been trimed (no trailing linebreak...)
    set -l line "$(commandline)"
    set -l buf_cur_idx (commandline -C) # utf-8 index
    set -l line_str_len (string length -- "$line")

    # if cursor not at eof
    if test "$line_str_len" -ne "$buf_cur_idx"
        commandline -f end-of-line
        return
    end

    set -l ent (fzf_files)
    commandline -f repaint

    if test -n "$line" # buffer is empty
        commandline -i -- "$ent"
        return
    end

    # if test -z "$ent"
    if test -d "$ent"
        cd "$ent"
    else if test -f "$ent"
        nvim "$ent"
    end
end
