#!/bin/sh
# TODO: status machine

hookid=${1:-0}
case $1 in
  qwe       ) hookid=0;;
  rdl       ) hookid=1;;
  cmk       ) hookid=2;;
  cps       ) hookid=3;;
  num       ) hookid=4;;
esac

polybar-msg action kmonad hook ${hookid}
