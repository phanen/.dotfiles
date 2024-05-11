function gib --wrap "paru -S"
    cd ~/src || return
    test -z $argv[1] && return
    cd $argv[1] && return
    paru -G $argv[1] || return
    cd $argv[1]
    #cp -v ~/archriscv-packages/$argv[1]/*.patch .
end

function gbi --wrap "paru -S"
    set -l name
    if not test -z $argv[1]
        set name $argv[1]
    else if test (path dirname (pwd)) = ~/src
        set name (path basename (pwd))
    else
        return 123
    end
    cp -v ~/archriscv-packages/$name/*.patch ~/src/$name
end
