# ~/b/fish-shell/share/functions/__fish_man_page.fish
function _fish_lookup
    set -l args (string match -rv '^-|^$' -- (commandline -cpo && commandline -t))
    if not set -q args[1]
        printf \a
        return
    end

    while set -q args[2]
        and string match -qr -- '^(and|begin|builtin|caffeinate|command|doas|entr|env|exec|if|mosh|nice|not|or|pipenv|prime-run|setsid|sudo|systemd-nspawn|time|watch|while|xargs|.*=.*)$' $args[1]
        set -e args[1]
    end

    set -l maincmd (basename $args[1])

    if set -q args[2]
        and not string match -q -- '*/*' $args[2]
        and tldr "$maincmd-$args[2]" &>/dev/null
        tldr "$maincmd-$args[2]"
    else
        if tldr "$maincmd" &>/dev/null
            echo
            tldr "$maincmd"
        else if type -q "$maincmd"
            echo
            type -a "$maincmd"
        else
            printf \a
        end
    end

    commandline -f repaint
end
