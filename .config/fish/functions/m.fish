# sc what you want
function m
    set dirs ~/notes ~/codes ~/stuffs ~/blog
    switch $argv
        # TODO: atomic logging...
        # TODO: error handler...
        case p
            for d in $dirs
                git -C $d pull &
            end
        case s
            for d in $dirs
                begin
                    git -C $d pull
                    git -C $d add .
                    git -C $d commit -m "chore: drink"
                    git -C $d push
                end &
            end
        case b
            echo not now
        case '*'
            echo sleep
    end
    wait
end
