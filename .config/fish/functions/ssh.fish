# TODO: kitty ssh cannot be nested
test $TERM = xterm-kitty
and function ssh --wrap ssh
    # fix error: completion reached maximum recursion depth, possible cycle?
    # TODO: Error: The SSH kitten is meant to run inside a kitty window
    kitty +kitten ssh $argv
end
