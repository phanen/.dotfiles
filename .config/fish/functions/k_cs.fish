function k_cs
    set -l line "$(commandline)"
    if test -z "$(string trim -- $line)"
        nvim
        return
    end
    if string match -r '^gib (.+)' $line &>/dev/null
        eval $line
        and $EDITOR +args\ % PKGBUILD riscv64.patch
        commandline -r ""
        commandline -f repaint
        return
    end
    __fish_man_page
end
