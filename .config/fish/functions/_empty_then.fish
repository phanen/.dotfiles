function _empty_then
    set -l line "$(commandline)"
    set -l buf_cur_idx (commandline -C) # utf-8 index
    set -l line_str_len (string length -- "$line")

    # commandline is not empty
    test "$line_str_len" -eq "$buf_cur_idx" && test -z "$line"
    and eval "$argv[1]; return"
    or eval $argv[2]
end
