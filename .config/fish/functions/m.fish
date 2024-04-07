# sc what you want
function m
    set dirs ~ ~/notes ~/codes ~/stuffs ~/blog
    switch $argv
        case p
            for d in $dirs
                git -C $d pull
            end
        case P
            for d in $dirs
                git -C $d add .
                git -C $d commit -m "chore: drink"
            end
        case b
            echo not now
        case '*'
            echo sleep
    end
end
