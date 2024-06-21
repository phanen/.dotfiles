#!/bin/bash
# grab all as much necessary input event as possible

# TODO: a udev rule
# TODO: spawn many processes is wasteful
# only keep a daemon for active kbd? but how to decide which is active..
# or we need a "lazy" machism?
cfg=~/.config/kmonad/kmonad.kbd
pkill -x kanata
pkill -x kmonad
# fd '^(usb|platform).+event-kbd$' /dev/input | while read kbd; do
cat /proc/bus/input/devices |
  cut -f 2- -d ' ' |
  perl -00ne 'if ($_ =~ /keyboard/i) {chomp($_); printf "%s\n",$_}' |
  grep -E -o "event[0-9]+" |
  while read ev; do
    echo $ev
    kmonad $cfg -w 0 -i "device-file \"/dev/input/$ev\"" &
  done
