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
