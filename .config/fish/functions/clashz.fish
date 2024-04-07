function clashz --wrap clash
    set -l src_cmd fd '.*\.yaml' $XDG_CONFIG_HOME/clash --type f
    set -l fzf_cmd fzf -1 \
        --preview "bat --color=always {}" \
        --bind="ctrl-o:execute(nvim {} &> /dev/tty)"
    set -l clash_cfg ($src_cmd | $fzf_cmd)
    test -f "$clash_cfg"; or return
    pkill -x clash
    # https://github.com/kovidgoyal/kitty/issues/307
    # systemd: why not we pipe out first few lines log as stdout...
    command clash -f $clash_cfg &>/dev/null & disown
end
