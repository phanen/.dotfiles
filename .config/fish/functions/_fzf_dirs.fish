function _fzf_dirs
    set cmd1 fd . -d 1 --type d -I
    set cmd2 zoxide query -l
    set cmd3 realpath ~/.local/share/nvim/lazy/* ~/dot/* ~/b/*

    set fzf fzf \
        --bind "ctrl-d:reload(zoxide remove {};$cmd1;$cmd2)" \
        --bind "ctrl-g:reload([[ -f /tmp/fish_k_cf ]] && { $cmd1; rm /tmp/fish_k_cf; true; } || { $cmd2; touch /tmp/fish_k_cf; })"

    # sort by zoxide frequency
    begin
        $cmd1
        $cmd2
        $cmd3
    end | sort | uniq | $fzf
    commandline -f repaint
end
