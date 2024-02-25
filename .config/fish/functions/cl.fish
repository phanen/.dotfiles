function cl
  if test -n $NVIM
    # https://github.com/neovim/neovim/issues/21403
    # https://github.com/neovim/neovim/issues/25245
    nvim --clean --headless --server $NVIM \
      --remote-send "<cmd>let scbk = &scbk | let &scbk = 0 | \
      let &scbk = scbk | unlet scbk<CR>" +'qa!' 2>/dev/null
    printf '\e[H\e[3J'
    command clear $argv
    return
  end
  printf \033\[2J\033\[3J\033\[1\;1H
end

