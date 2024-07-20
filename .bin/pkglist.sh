#!/bin/sh
# XDG_CONFIG_HOME not known in cron
BASE=/home/phan/.config/pkglists/$(hostnamectl hostname)
mkdir -p $BASE
pacman -Qqen > $BASE/nativepkglist
pacman -Qqem > $BASE/foreignpkglist

sudo checkupdates --download; true
