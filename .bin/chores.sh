#!/bin/sh

gen_pkglist() {
  command -v pacman 1>/dev/null || return
  command -v checkupdates 1>/dev/null || return

  # XDG_CONFIG_HOME not known in cron
  BASE=$HOME/.config/pkglists/$(hostnamectl hostname)
  mkdir -p "$BASE"

  pacman -Qqen >"$BASE"/nativepkglist
  pacman -Qqem >"$BASE"/foreignpkglist

  sudo checkupdates --download
  true
}

gen_pkglist
command -v fish && fish -c 'fish_update_completions'
command -v tldr 1>/dev/null && tldr --update
