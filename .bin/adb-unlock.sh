#!/usr/bin/env bash

for i in "$@"; do
  case $i in
  -w | --wake-only) WAKE_ONLY=1 ;;

    # https://unix.stackexchange.com/questions/577603/possible-to-match-multiple-conditions-in-one-case-statement
  -s) HOST="$2" ;;&
  *) ADB_ARGS+=("$i") ;;
  esac
done

adb connect "$HOST"
adb "${ADB_ARGS[@]}" shell input keyevent KEYCODE_WAKEUP
[ -n "$WAKE_ONLY" ] && exit 0
sleep .3

adb "${ADB_ARGS[@]}" shell input swipe 500 1200 500 100
sleep .3

adb "${ADB_ARGS[@]}" shell input tap 250 1080
adb "${ADB_ARGS[@]}" shell input tap 250 1360
adb "${ADB_ARGS[@]}" shell input tap 550 1080
adb "${ADB_ARGS[@]}" shell input tap 550 1360
adb "${ADB_ARGS[@]}" shell input tap 820 1880

if ! pgrep scrcpy; then
  scrcpy -Sw "${ADB_ARGS[@]}"
fi
