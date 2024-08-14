#!/bin/sh

command -q pacman || exit 1
command -q checkupdates || exit 1

# XDG_CONFIG_HOME not known in cron
BASE=$HOME/.config/pkglists/$(hostnamectl hostname)
mkdir -p "$BASE"

pacman -Qqen >"$BASE"/nativepkglist
pacman -Qqem >"$BASE"/foreignpkglist

sudo checkupdates --download
true
