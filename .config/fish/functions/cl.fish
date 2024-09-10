function cl
    if test -n $NVIM
        # https://github.com/neovim/neovim/issues/21403
        # https://github.com/neovim/neovim/issues/25245
        command nvim --clean --headless --server $NVIM \
            --remote-send "<cmd>let scbk=&scbk|let &scbk=0|let &scbk=scbk|unlet scbk<cr>" +'qa!' 2>/dev/null
        printf '\e[H\e[3J'
        printf '\e[2J\e[3J\e[1;1H'
        # command clear $argv
        return
    end
    printf \033\[2J\033\[3J\033\[1\;1H
end
