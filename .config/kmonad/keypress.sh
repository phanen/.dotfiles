#!/bin/sh

hookid=${1:-0}
case $1 in
  qwe       ) hookid=0;;
  nor       ) hookid=1;;
  vis       ) hookid=2;;
  cmk       ) hookid=3;;
  sym       ) hookid=4;;
esac
polybar-msg action kmonad hook ${hookid}
