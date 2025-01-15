function toggle-commandline
    set -l line (commandline)
    if string match -qr '^fzf' $line then
        fish_commandline_prepend "FZF_DEFAULT_OPTS="
    end
end
