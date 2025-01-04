function _bs_or_del
    set -l line "$(commandline)"
    set -l buf_cur_idx (commandline -C) # utf-8 index
    set -l line_str_len (string length -- "$line")
    if test "$line_str_len" -ne "$buf_cur_idx"; or test -z "$line"
        commandline -f delete-or-exit
        return
    end
    commandline -f backward-delete-char
end
