function w --wrap watch
    argparse -n watch --max-args=1 n/interval= -- $argv
    set -q _flag_interval; or set _flag_interval 1
    while true
        eval $argv
        sleep $_flag_interval
        clear
    end
end
