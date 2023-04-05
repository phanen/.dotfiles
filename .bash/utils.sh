append_path(){
    # [ "$(id -u)" -ge 1000 ] || return
    for p in "$@";
    do
        [ -d "$p" ] || continue
        echo "$PATH" | grep -Eq "(^|:)$p(:|$)" && continue
        export PATH="${PATH:+$PATH:}$p"
    done
}

prepend_path(){
    # [ "$(id -u)" -ge 1000 ] || return
    for p in "$@";
    do
        [ -d "$p" ] || continue
        echo "$PATH" | grep -Eq "(^|:)$p(:|$)" && continue
        export PATH="$p${PATH:+:$PATH}"
    done
}

cdev() { append_path "$HOME/demo/dev/depot_tools"; }
