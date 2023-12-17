# PATH is exported in /etc/profile
append_path () {
    case ":$PATH:" in
        *:"$1":*)
            ;;
        *)
            PATH="${PATH:+$PATH:}$1"
    esac
}
append_path $HOME/.bin
append_path $HOME/.local/bin
append_path $HOME/.cargo/bin
append_path $HOME/.config/nvim/mason/bin

export EDITOR=nvim
export VISUAL=nvim
export TERMINAL=alacritty
export BROWSER=google-chrome-stable
export PDF="google-chrome-stable"
export FETCHER=uwufetch
export MANPAGER='nvim +Man!'
export MANWIDTH=80

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

export http_proxy="http://127.0.0.1:7890"
export https_proxy=$http_proxy
export ftp_proxy=$http_proxy
export rsync_proxy=$http_proxy
export all_proxy=$http_proxy
export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"

# fcitx5, officially place in pam_env... but also works here
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export SDL_IM_MODULE=fcitx
export GLFW_IM_MODULE=ibus

# always use posix shell to exec script
export SXHKD_SHELL='/usr/bin/sh'

# dark mode
# export GTK_THEME=Adwaita-dark
# export GTK2_RC_FILES=/usr/share/themes/Adwaita-dark/gtk-2.0/gtkrc
# export QT_STYLE_OVERRIDE=adwaita-dark
# gsettings set org.gnome.desktop.interface color-scheme prefer-dark

# fix swing gui
export _JAVA_AWT_WM_NONREPARENTING=1

# export LIBRARY_PATH=$LIBRARY_PATH:/opt/cuda/include/
# export CPATH=$CPATH:/opt/cuda/include/
# export PATH=$PATH:/opt/cuda/bin/

export RUSTUP_DIST_SERVER="https://rsproxy.cn"
export RUSTUP_UPDATE_ROOT="https://rsproxy.cn/rustup"

# chores
export NEMU_HOME=$HOME/ysyx-workbench/nemu
export NPC_HOME=$HOME/ysyx-workbench/npc
export NVBOARD_HOME=$HOME/ysyx-workbench/nvboard

# remove all but the last identical command, and commands that start with a space
export HISTCONTROL="erasedups:ignorespace"

# 启动 wayland 桌面前设置一些环境变量
function set_wayland_env
{
  # 解决QT程序缩放问题
  export QT_AUTO_SCREEN_SCALE_FACTOR=1
  # QT使用wayland和gtk
  export QT_QPA_PLATFORM="wayland;xcb"
  export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
  # 使用qt5ct软件配置QT程序外观
  export QT_QPA_PLATFORMTHEME=qt5ct

  # 一些游戏使用wayland
  export SDL_VIDEODRIVER=wayland
  # 解决java程序启动黑屏错误
  export _JAVA_AWT_WM_NONEREPARENTING=1
  # GTK后端为 wayland和x11,优先wayland
  export GDK_BACKEND="wayland,x11"
}

# 命令行输入这个命令启动hyprland,可以自定义
function start_hyprland
{
  set_wayland_env

  export XDG_SESSION_TYPE=wayland
  export XDG_SESSION_DESKTOP=Hyprland
  export XDG_CURRENT_DESKTOP=Hyprland
  # 启动 Hyprland程序
  Hyprland
}
