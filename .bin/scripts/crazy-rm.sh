#!/bin/bash
paccache -rk0
rm -rf .cache/joshuto/*
rm -rf .cache/vifm/*

pacman -Qqd | sudo pacman -Rsu  -
cargo-clean-all
 rm .local/share/Trash/ -rf
