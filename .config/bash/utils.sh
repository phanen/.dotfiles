_util_append_path(){
    # [ "$(id -u)" -ge 1000 ] || return
    for p in "$@"; do
        [ -d "$p" ] || continue
        echo "$PATH" | grep -Eq "(^|:)$p(:|$)" && continue
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
  # sudo dhcpcd &&
  sudo rfkill unblock wifi
  # sudo ip a add 192.168.1.222/24 dev wlp0s20f3 &&
  # sudo ip r add default via 192.168.1.1 dev wlp0s20f3 &&
  # sudo wpa_supplicant -B -i wlp0s20f3 -c /etc/wpa_supplicant/wpa_supplicant.conf &&
}

# xinput --set-prop 16 'libinput Accel Speed' 1
