set -gx BASHRC_DIR "$HOME"'/.config/bash'
function _util_append_path
  for p in "$argv"
    [ -d "$p" ] || continue
    echo "$PATH" | grep -Eq '(^|:)'"$p"'(:|''$'')' && continue
    set -gx PATH (test -n "$PATH" && echo "$PATH"':' || echo)"$p"
  end
end
function _util_prepend_path
  for p in "$argv"
    [ -d "$p" ] || continue
    echo "$PATH" | grep -Eq '(^|:)'"$p"'(:|''$'')' && continue
    set -gx PATH "$p"(test -n "$PATH" && echo ':'"$PATH" || echo)
  end
end
function _util_netcfg
  sudo rfkill unblock wifi
end
set -gx EDITOR 'nvim'
set -gx VISUAL 'nvim'
set -gx TERMINAL 'alacritty'
[ -n "$DISPLAY" ] && set -gx BROWSER 'google-chrome-stable' || set -gx BROWSER 'links'
set -gx PDF 'google-chrome-stable'
set -gx FETCHER 'uwufetch'
set -gx MANPAGER 'nvim +Man!'
set -gx MANWIDTH '80'
set -gx LESS_TERMCAP_mb (printf '\\e[01;31m' | string collect; or echo)
set -gx LESS_TERMCAP_md (printf '\\e[01;35m' | string collect; or echo)
set -gx LESS_TERMCAP_me (printf '\\e[0m' | string collect; or echo)
set -gx LESS_TERMCAP_se (printf '\\e[0m' | string collect; or echo)
set -gx LESS_TERMCAP_so (printf '\\e[01;33m' | string collect; or echo)
set -gx LESS_TERMCAP_ue (printf '\\e[0m' | string collect; or echo)
set -gx LESS_TERMCAP_us (printf '\\e[04;36m' | string collect; or echo)
set -gx XDG_CONFIG_HOME "$HOME"'/.config'
set -gx XDG_CACHE_HOME "$HOME"'/.cache'
set -gx XDG_DATA_HOME "$HOME"'/.local/share'
set -gx XDG_STATE_HOME "$HOME"'/.local/state'
set -gx XDG_DATA_DIRS '/usr/local/share:/usr/share'
set -gx XDG_CONFIG_DIRS '/etc/xdg'
set -gx HISTCONTROL 'erasedups:ignorespace:ignoreboth'
set -gx http_proxy 'http://127.0.0.1:7890'
set -gx https_proxy "$http_proxy"
set -gx ftp_proxy "$http_proxy"
set -gx rsync_proxy "$http_proxy"
set -gx all_proxy "$http_proxy"
set -gx no_proxy 'localhost,127.0.0.1,localaddress,.localdomain.com'
set -gx GTK_THEME 'Adwaita'
set -gx GTK2_RC_FILES '/usr/share/themes/Adwaita/gtk-2.0/gtkrc'
set -gx QT_STYLE_OVERRIDE 'adwaita'
set -gx EDK_TOOLS_PATH "$HOME"'/demo/os/edk2/BaseTools'
set -gx _JAVA_AWT_WM_NONREPARENTING '1'
set -gx RUSTUP_DIST_SERVER 'https://rsproxy.cn'
set -gx RUSTUP_UPDATE_ROOT 'https://rsproxy.cn/rustup'
set -gx NEMU_HOME "$HOME"'/ysyx-workbench/nemu'
set -gx NPC_HOME "$HOME"'/ysyx-workbench/npc'
set -gx NVBOARD_HOME "$HOME"'/ysyx-workbench/nvboard'
_util_append_path "$HOME"'/.bin'
_util_append_path "$XDG_DATA_HOME"'/nvim/mason/bin'
_util_append_path "$HOME"'/.local/bin'
_util_append_path "$HOME"'/.cargo/bin'
_util_append_path "$XDG_CONFIG_HOME"'/emacs/bin'
alias e='$EDITOR'
alias v='nvim'
alias k='pkill'
alias x='xsel'
alias t='type'
alias p='sudo pacman'
alias y='yay'
alias s='sysz'
alias ls='exa --color=auto'
alias ll='ls -lah'
alias la='ls -a'
alias l='ll'
alias lt='ls --tree'
alias lta='ls -a --tree'
alias grep='grep --color'
alias df='df -h'
alias which='which -a'
alias type='type -a'
alias hx='hexdump'
alias tl='tldr'
alias mx='chmod +x'
alias rx='chmod -x'
alias vi='nvim'
alias vn='vi -u NONE'
alias si='sudo -E vi'
alias du='dust'
alias em='emacs -nw'
alias hl='helix'
alias nf='uwufetch'
alias lg='lazygit'
alias ua='sudo umount -R /mnt'
alias hm='l | wc -l'
alias cs='cd '"$XDG_STATE_HOME"'/nvim/swap/'
alias ok='echo $status'
alias kc='pkill kmonad; kmonad ~/.config/kmonad/kmonad-cb.kbd -w 50 & disown'
alias kh='pkill kmonad; kmonad ~/.config/kmonad/kmonad-hs.kbd -w 50 & disown'
alias pi='sudo pacman -S'
alias pd='sudo pacman -Rns'
alias pu='sudo pacman -Syu'
alias pao='pacman -Qo'
alias pfo='pacman -F'
alias pai='pacman -Qi'
alias psi='pacman -Si'
alias pal='pacman -Ql'
alias pfl='pacman -Fl'
alias pag='pacman -Ql 2>&1|rg'
alias pfg='pacman -Fl 2>&1|rg'
alias pas='pacman -Qs'
alias pss='pacman -Ss'
alias psc='pacscripts'
alias ys='yay -Ss'
alias yss='yay -Ss'
alias ysi='yay -Si'
alias yi='yay -S'
alias patt='pactree -lu'
alias pato='pactree -d 1 -o -lu'
alias pat='pactree -d 1 -lu'
alias par='pactree -r -lu'
alias pst='pactree -slu'
alias psr='pactree -r -slu'
alias apt='asp export'
alias mkp='makepkg -do --skippgpcheck'
alias pov='podman volume'
alias por='podman run'
alias todo="$EDITOR"' '"$HOME"'/notes/todo.md'
alias log="$EDITOR"' '"$HOME"'/LOG.md'
alias vifm='vifmrun'
alias rigdb='riscv64-linux-gnu-gdb'
alias ppush='rclone sync papers gd:papers -P'
alias ppull='rclone sync gd:papers papers -P'
set LFCD "$XDG_CONFIG_HOME"'/lf/lfcd.sh'
[ -f "$LFCD" ] && babelfish < "$LFCD" | source
function fsl
  fzf -m --margin 5% --padding 5% --border --preview 'cat {}'
end
function fhs
  stty -echo && history | grep ''$argv | awk '{$1=$2=$3=""; print $0}' | fzf | xargs -I {} xdotool type {} && stty echo
end
function fy
  fzf | tr -d '\\n' | xsel -b
end
function fv
  $VISUAL (fzf | string collect; or echo)
end
function fp
  $PDF (fzf | string collect; or echo) >/dev/null 2>&1
end
function fcl
  set CLASH_CONFIG (find .config/clash -type f -name '*.yaml' | fzf | string collect; or echo)
  test -n "$CLASH_CONFIG" && clash -f $CLASH_CONFIG || exit
end
function diskcheck
  fish -c 'sudo smartctl -a /dev/nvme0n1; sudo smartctl -a /dev/nvme1n1' | rg 'Percentage Used' -C10
end
function archman
  curl -sL 'https://man.archlinux.org/man/'$argv[1]'.raw' | man -l -
end
function toggle_proxy
  set -e http_proxy; set -e https_proxy; set -e all_proxy
end
function clip2img
  xclip -selection clipboard -target image/png -o >$argv[1].png
end
function vis
  set -l CONFIG (find ~/.config/nvim*/ -prune -exec basename {} \; | string collect; or echo)
  set -l SELECTED (printf '%s\\n' $CONFIG | fzf --prompt='Neovim Config >>' --height=~50% --layout=reverse --border --exit-0 | string collect; or echo)
  echo $SELECTED
  if test -z "$SELECTED"
    echo 'Nothing selected'
    return 0
  else if test "$SELECTED" = 'default'
    set SELECTED ''
  end
  NVIM_APPNAME="$SELECTED" nvim $argv
end
function gitit
  git remote add origin git@github.com:phanen/phanen.git
  git branch -M master
  git push -u origin master
end
function gitp
  git checkout HEAD^1
end
function gitn
  git log --reverse --pretty=%H $argv[1] | grep -A 1 (git rev-parse HEAD) | tail -n1 | xargs git checkout
end
function vw
  vi (which $argv[1] | head -1 | string collect; or echo)
end
function fw
  file (which $argv[1] | head -1 | string collect; or echo)
end
function lw
  ls -la (which $argv[1] | head -1 | string collect; or echo)
end
function pzip
  tar -c --use-compress-program=pigz -f $argv[1].tar.gz $argv[1]
end
function da2b
  dd bs=4M if=$argv[1] of=$argv[2] status=progress && sync
end
function dev-monitor
  udevadm monitor --environment --udev
end
function ni
  cd ~/notes && nvim (fzf | string collect; or echo)
end
function rs
  exec $SHELL
end
set -gx CHROOT "$HOME"'/chroot/'
set -gx CACHE_DIR "$HOME"'/pkg/'
set -gx USERNAME 'phanen'
alias rb='extra-riscv64-build -- -d '"$CACHE_DIR"':/var/cache/pacman/pkg'
alias crb='extra-riscv64-build -c -- -d '"$CACHE_DIR"':/var/cache/pacman/pkg'
alias xb='extra-x86_64-build -- -d '"$HOME"'/xpkg:/var/cache/pacman/pkg'
alias cxb='extra-x86_64-build -c -- -d '"$HOME"'/xpkg:/var/cache/pacman/pkg'
alias lb='/bin/ls /var/lib/archbuild/extra-riscv64/*/build'
function m
  mkdir -p $argv[1] && cd $argv[1]
end
alias zz='m /tmp/tmp; yay -G'
function rv-patch
  git diff --no-prefix --relative | tail -n +3 >riscv64.patch
end
function rv-ent
  sudo systemd-nspawn -D ~/plct/archriscv/ --machine archriscv -a -U
end
function ptos
  cp *.patch ~/src/$argv[1]
end
function upd-keyring
  sudo arch-chroot /var/lib/archbuild/extra-riscv64/root pacman -Syu
end
function __init_rv_pkg
  cd ~
  mkdir src pkg
  sudo pacman -Sy --noconfirm pkgctl devtools-riscv64
  git clone git@github.com:$USERNAME/archriscv-packages.git
  cd archriscv-packages
  git remote add upstream https://github.com/felixonmars/archriscv-packages.git
end
function peek
  babelfish < ./PKGBUILD | source
  echo arch='('$arch')'
  for s in $source
    echo $s
  end
  for s in $_commit
    echo $s
  end
end
function add-key
  babelfish < ./PKGBUILD | source
  for key in $validpgpkeys
    echo 'Receiving key '"$key"'...'
    gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys "$key" || true
    gpg --keyserver hkps://keys.openpgp.org --recv-keys "$key" || true
  end
end
function gib
  set fname $argv[1]
  test -z $fname && cd ~/src && return
  gib
  cd $fname && peek && return
  yay -G $fname || return
  cd $fname
  peek
  add-key
  cp ~/archriscv-packages/$fname/*.patch .
end
function pie
  set fname $argv[1]
  test -z $fname && cd ~/archriscv-packages && return
  cd ~/src/$fname || return
  rv-patch
  cat riscv64.patch
  babelfish < ./PKGBUILD | source
  echo -n "$fname"' '"$pkgver"'-'"$pkgrel" | xsel
  pie
  echo 'Pulling from upstream (Fast-Forward Only)...'
  git checkout master
  git pull --ff-only upstream master:master
  git push
  git checkout -b "$fname" || git checkout "$fname"
  git rebase master
  mkdir -p ~/archriscv-packages/"$fname"
  cd $fname
  cp ~/src/$fname/*.patch .
  test -s riscv64.patch || rm *.patch
end
function find-old
  ag -l autoreconf | xargs -I {} sh -c 'git log -1 --pretty="format:%ci" {} && echo \\ {}' | tee /tmp/.tmp-gitdate && echo /tmp/.tmp-gitdate
end
function baklog
  find . -name '*.log' | xargs -I{} cp {} {}1.log
end
set which_shell (ps -o comm= -p $fish_pid | string collect; or echo)
test "$which_shell" != 'fish' && stty stop undef
switch (tty | string collect; or echo)
case '*tty*'
  setfont ter-d28b
case '*'
  
end
