function k_enter
    set -l line (commandline)
    #if string match -r "^https?://github.+" $line &>/dev/null
    if string match -r "^https?://+" $line &>/dev/null
        or string match -r "^git@github.+" $line &>/dev/null
        set line (string replace -r ' +' ' ' -- $line | string split ' ')
        if test (pwd) = "$HOME/dot" -a (count $line) -eq 1
            set line (string replace -r '^.+[:/](.+)/(.+)$' '$0 $1-$2' $line)
        end
        commandline -r "git clone $line"
        return
    end

    # https://www.reddit.com/r/fishshell/
    # tput cup $COLUMNS 30

    commandline -f execute
end
