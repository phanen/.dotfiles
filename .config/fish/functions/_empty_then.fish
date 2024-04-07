function _empty_then
    test -z "$(commandline)"
    and eval "$argv[1]; return"
    or eval $argv[2]
end
