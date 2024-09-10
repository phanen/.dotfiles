function nvimz --wrap nvim
    set -qx NVIM_BIN
    or set NVIM_BIN nvim

    echo $NVIM_BIN
    set -lx NVIM_APPNAME (fd 'init.lua' ~/.config/ -I -d 2 --prune -F -x basename {//} | fzf -1 --preview 'bat -f ~/.config/{}/init.lua' -0)
    $NVIM_BIN $argv
end
