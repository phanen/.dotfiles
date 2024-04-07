function kmonadz --wrap kmonad
    pkill -x kmonad
    # https://github.com/sharkdp/bat/issues/1600
    set -l cfg (fd ".*\.kbd"  ~/.config/kmonad/ --type f  | fzf -1 --preview 'bat --color=always {}')
    cat /proc/bus/input/devices |
        cut -f 2- -d ' ' |
        perl -00ne 'if ($_ =~ /keyboard/i) {chomp($_); printf "%s\n",$_}' |
        grep -E -o "event[0-9]+" |
        while read ev
            command kmonad $cfg -w 0 -i "device-file \"/dev/input/$ev\"" & disown
        end
end
