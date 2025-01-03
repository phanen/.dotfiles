function ff --wrap "paru -G"
    mkdir -p /tmp/tmp
    cd /tmp/tmp
    command -q paru
    and paru -G $argv
    or true
end
