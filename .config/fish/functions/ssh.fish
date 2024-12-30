test $TERM = xterm-kitty; and set -q KITTY_PID; and set -q KITTY_WINDOW_ID
and function ssh --wrap ssh
    kitten ssh $argv
end
