#!/bin/sh
BASE=$XDG_CONFIG_HOME/pkglists/$(hostnamectl hostname)
mkdir -p $BASE
pacman -Qqen > $BASE/nativepkglist
pacman -Qqem > $BASE/foreignpkglist
