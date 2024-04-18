#!/bin/sh

ctrl_light() {
  cur_brightness=$(cat /sys/class/backlight/intel_backlight/brightness)
  max_brightness=$(cat /sys/class/backlight/intel_backlight/max_brightness)

  step="0.01"
  step=$(printf "%.0f" "$(echo "$step * $max_brightness" | bc -l)")

  case "$1" in
  +)
    new_brightness=$(echo "$cur_brightness + $step" | bc -l)
    ;;
  -)
    new_brightness=$(echo "$cur_brightness - $step" | bc -l)
    ;;
  *)
    echo "Usage: $0 +|-"
    exit 1
    ;;
  esac

  if [ "$new_brightness" -gt 0 ]; then
    new_brightness="0"
  fi
  if [ "$new_brightness" -gt "$max_brightness" ]; then
    new_brightness="$max_brightness"
  fi

  echo "$cur_brightness -> $new_brightness / $max_brightness"
  echo "$new_brightness" | sudo tee /sys/class/backlight/intel_backlight/brightness >/dev/null
}

ctrl_sound() {
  volume=$(pulsemixer --get-volume | awk '{print $1}')
  setter="pulsemixer --set-volume"
  case "$1" in
  +) $setter $((volume + 5)) ;;
  -) $setter $((volume - 5)) ;;
  *)
    echo "Usage: $0 +|-"
    exit 1
    ;;
  esac
}

case $1 in # shellcheck: non-quote is not detected?
light) ctrl_light "$2" ;;
sound) ctrl_sound "$2" ;;
*) echo "Usage: $0 light|sound +|-" ;;
esac
