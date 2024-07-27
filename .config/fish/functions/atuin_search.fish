# _atuin_search
# generated from autin init, ignore vi-keybinding

command -q atuin
or return

function atuin_search
    set -lx ATUIN_SHELL_FISH t
    set -lx ATUIN_LOG error

    set -l search_cmd atuin search --keymap-mode=emacs

    set -l ATUIN_H
    if count $argv >/dev/null
        set ATUIN_H ($search_cmd -i $argv 3>&1 1>&2 2>&3 | string collect)
    else
        set -lx ATUIN_QUERY (builtin commandline -b)
        # no $argv provided: fallback to ATUIN_QUERY
        set ATUIN_H ($search_cmd -i 3>&1 1>&2 2>&3 | string collect)
    end

    # parse result
    if test -n "$ATUIN_H"
        if string match -q '__atuin_accept__:*' "$ATUIN_H"
            # run selected immediately
            set -l ATUIN_HIST (string replace "__atuin_accept__:" "" -- "$ATUIN_H" | string collect)
            builtin commandline -r "$ATUIN_HIST"
            builtin commandline -f repaint
            builtin commandline -f execute
            return
        else
            builtin commandline -r "$ATUIN_H"
        end
    end

    builtin commandline -f repaint
end
