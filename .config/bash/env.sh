export EDITOR=nvim
export VISUAL=nvim
export TERMINAL=alacritty
[ -n "$DISPLAY" ] && export BROWSER=google-chrome-stable || export BROWSER=links
export PDF="google-chrome-stable"
export FETCHER=uwufetch
# export MANPAGER="/bin/sh -c \"col -b | nvim -u NORC -c 'set ft=man ts=8 nomod nolist nonu noma' -\""
# export MANPAGER="/bin/sh -c \"col -b | nvim -c 'set ft=man ts=8 nomod nolist nonu noma' -\""
export MANPAGER='nvim +Man!'
export MANWIDTH=80

# export PAGER="most"
export LESS_TERMCAP_mb=$(printf '\e[01;31m') # enter blinking mode - red
export LESS_TERMCAP_md=$(printf '\e[01;35m') # enter double-bright mode - bold, magenta
export LESS_TERMCAP_me=$(printf '\e[0m')     # turn off all appearance modes (mb, md, so, us)
export LESS_TERMCAP_se=$(printf '\e[0m')     # leave standout mode
export LESS_TERMCAP_so=$(printf '\e[01;33m') # enter standout mode - yellow
export LESS_TERMCAP_ue=$(printf '\e[0m')     # leave underline mode
export LESS_TERMCAP_us=$(printf '\e[04;36m') # enter underline mode - cyan

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_DATA_DIRS="/usr/local/share:/usr/share"
export XDG_CONFIG_DIRS="/etc/xdg"
export HISTCONTROL="erasedups:ignorespace:ignoreboth"

export http_proxy="http://127.0.0.1:7890"
export https_proxy=$http_proxy
export ftp_proxy=$http_proxy
export rsync_proxy=$http_proxy
export all_proxy=$http_proxy
export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"

# dark mode
# export GTK_THEME=Adwaita-dark
# export GTK2_RC_FILES=/usr/share/themes/Adwaita-dark/gtk-2.0/gtkrc
export GTK_THEME=Adwaita
export GTK2_RC_FILES=/usr/share/themes/Adwaita/gtk-2.0/gtkrc
export QT_STYLE_OVERRIDE=adwaita

export EDK_TOOLS_PATH=$HOME/demo/os/edk2/BaseTools

export _JAVA_AWT_WM_NONREPARENTING=1

# export LIBRARY_PATH=$LIBRARY_PATH:/opt/cuda/include/
# export CPATH=$CPATH:/opt/cuda/include/
# export PATH=$PATH:/opt/cuda/bin/

# export sduwifi=101.76.193.1

# gsettings set org.gnome.desktop.interface color-scheme prefer-dark
export RUSTUP_DIST_SERVER="https://rsproxy.cn"
export RUSTUP_UPDATE_ROOT="https://rsproxy.cn/rustup"

# chores
export NEMU_HOME=$HOME/ysyx-workbench/nemu
export NPC_HOME=$HOME/ysyx-workbench/npc
export NVBOARD_HOME=$HOME/ysyx-workbench/nvboard

