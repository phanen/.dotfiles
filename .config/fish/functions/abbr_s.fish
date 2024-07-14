function abbr_s
    set -l proc (commandline -p)
    if string match -q -r systemctl $proc
        echo status
    else
        echo systemctl
    end
end
