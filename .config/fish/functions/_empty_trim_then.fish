function _empty_trim_then
    test -z "$(string trim -- $(commandline))"
    and eval "$argv[1]; return"
    or eval $argv[2]
end
