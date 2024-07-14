# _atuin_search
# generated from autin init, ignore vi-keybinding
function k_cr
    command -q atuin
    or return

    # if no argv, then fallback to ATUIN_QUERY
    set -l ATUIN_H "$(ATUIN_SHELL_FISH=t ATUIN_LOG=error ATUIN_QUERY=(commandline -b) atuin search --keymap-mode=emacs $argv -i 3>&1 1>&2 2>&3 | string collect)"

    if test -n "$ATUIN_H"
        if string match -q '__atuin_accept__:*' "$ATUIN_H"
            set -l ATUIN_HIST (string replace "__atuin_accept__:" "" -- "$ATUIN_H" | string collect)
            commandline -r "$ATUIN_HIST"
            commandline -f repaint
            commandline -f execute
            return
        else
            commandline -r "$ATUIN_H"
        end
    end

    commandline -f repaint
end
