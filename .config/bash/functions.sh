# shellcheck source=/dev/null

LFCD="$XDG_CONFIG_HOME/lf/lfcd.sh"
[ -f "$LFCD" ] && . "$LFCD"

# awesome fzf
fsl() { fzf -m --margin 5% --padding 5% --border --preview 'cat {}'; }
fhs() { stty -echo && history | grep ""$@ | awk '{$1=$2=$3=""; print $0}' | fzf | xargs -I {} xdotool type {} && stty echo; }
fy() { fzf | tr -d "\n" | xsel -b; }
fv() { $VISUAL "$(fzf)"; }
fp() { $PDF "$(fzf)" >/dev/null 2>&1; }

fcl() {
  # cd "${XDG_CONFIG_HOME}"/clash/ || exit
  # ln -sf $(ls *.yaml | fzf) config.yaml
  # clash
  CLASH_CONFIG=$(find .config/clash -type f -name "*.yaml" | fzf)
  [[ -n $CLASH_CONFIG ]] && clash -f $CLASH_CONFIG || exit
}

diskcheck() {
# https://stackoverflow.com/questions/35005915/using-watch-to-run-a-function-repeatedly-in-bash
  (
    sudo smartctl -a /dev/nvme0n1
    sudo smartctl -a /dev/nvme1n1
  ) | rg "Percentage Used" -C10
}

archman() { curl -sL "https://man.archlinux.org/man/$1.raw" | man -l -; }

toggle_proxy() { unset http_proxy https_proxy all_proxy; }

clip2img() { xclip -selection clipboard -target image/png -o >$1.png; }

vis() {
  local CONFIG="$(find ~/.config/nvim*/ -prune -exec basename {} \;)"
  local SELECTED=$(printf "%s\n" "${CONFIG[@]}" | fzf --prompt="Neovim Config >>" --height=~50% --layout=reverse --border --exit-0)
  echo $SELECTED
  if [[ -z $SELECTED ]]; then
    echo "Nothing selected"
    return 0
  elif [[ $SELECTED == "default" ]]; then
    SELECTED=""
  fi
  NVIM_APPNAME=$SELECTED nvim $@
}

gitit() {
  git remote add origin git@github.com:phanen/phanen.git
  git branch -M master
  git push -u origin master
}
gitp() {
  git checkout HEAD^1
}
gitn() {
  git log --reverse --pretty=%H ${1-master} | grep -A 1 $(git rev-parse HEAD) | tail -n1 | xargs git checkout
}

vw() { vi "$(which $1 |head -1)"; }
fw() { file "$(which $1 |head -1)"; }
lw() { ls -la "$(which $1 |head -1)"; }

pzip() { tar -c --use-compress-program=pigz -f "$1".tar.gz $1; }
da2b() { dd bs=4M if="$1" of="$2" status=progress && sync; }

dev-monitor() { udevadm monitor --environment --udev; }

ni() { cd ~/notes && nvim "$(fzf)"; }

rs() { exec $SHELL; }
