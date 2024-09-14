#!/bin/sh

command -v pacman 1>/dev/null || exit 1
command -v checkupdates 1>/dev/null || exit 1

# XDG_CONFIG_HOME not known in cron
BASE=$HOME/.config/pkglists/$(hostnamectl hostname)
mkdir -p "$BASE"

pacman -Qqen >"$BASE"/nativepkglist
pacman -Qqem >"$BASE"/foreignpkglist

sudo checkupdates --download
true
