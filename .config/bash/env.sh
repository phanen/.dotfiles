export EDITOR=nvim
export VISUAL=nvim
export TERMINAL=alacritty
[ -n "$DISPLAY" ] && export BROWSER=chromium || export BROWSER=links
export PDF="chromium"
# export MANPAGER="/bin/sh -c \"col -b | nvim -u NORC -c 'set ft=man ts=8 nomod nolist nonu noma' -\""
export MANPAGER="/bin/sh -c \"col -b | nvim -c 'set ft=man ts=8 nomod nolist nonu noma' -\""
# export PAGER="most"
# export LESS_TERMCAP_mb=$(printf '\e[01;31m') # enter blinking mode - red
# export LESS_TERMCAP_md=$(printf '\e[01;35m') # enter double-bright mode - bold, magenta
# export LESS_TERMCAP_me=$(printf '\e[0m')     # turn off all appearance modes (mb, md, so, us)
# export LESS_TERMCAP_se=$(printf '\e[0m')     # leave standout mode
# export LESS_TERMCAP_so=$(printf '\e[01;33m') # enter standout mode - yellow
# export LESS_TERMCAP_ue=$(printf '\e[0m')     # leave underline mode
# export LESS_TERMCAP_us=$(printf '\e[04;36m') # enter underline mode - cyan
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_DATA_DIRS="/usr/local/share:/usr/share"
export XDG_CONFIG_DIRS="/etc/xdg"

export HISTCONTROL="erasedups:ignorespace:ignoreboth"

# proxy
export http_proxy="http://127.0.0.1:7890"
export https_proxy="http://127.0.0.1:7890"
export all_proxy="http://127.0.0.1:7890"

export EDK_TOOLS_PATH=$HOME/demo/hard/edk2/BaseTools

export CHROOT=$HOME/chroot
export dev_dir="$HOME/demo/ndev"

FETCHER=uwufetch
