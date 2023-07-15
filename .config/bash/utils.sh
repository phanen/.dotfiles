_util_append_path(){
    # [ "$(id -u)" -ge 1000 ] || return
    for p in "$@"; do
        [ -d "$p" ] || continue
        echo "$PATH" | grep -Eq "(^|:)$p(:|$)" && continue
        # warn: fish path is split by space rathan than semicolon
        export PATH="${PATH:+$PATH:}$p"
    done
}

_util_prepend_path(){
    # [ "$(id -u)" -ge 1000 ] || return
    for p in "$@";
    do
        [ -d "$p" ] || continue
        echo "$PATH" | grep -Eq "(^|:)$p(:|$)" && continue
        export PATH="$p${PATH:+:$PATH}"
    done
}

_util_netcfg() {
    sudo rfkill unblock wifi

    # no systemd
    # local use_dhcp = 1
    # if [[ test $use_dhcp -eq 1 ]]; then
    #     sudo dhcpcd
    # else # stastic
    #   sudo ip a add 192.168.1.222/24 dev wlp0s20f3 &&
    #   sudo ip r add default via 192.168.1.1 dev wlp0s20f3
    #   sudo wpa_supplicant -B -i wlp0s20f3 -c /etc/wpa_supplicant/wpa_supplicant.conf &&
    # fi
}

# xinput --set-prop 16 'libinput Accel Speed' 1
