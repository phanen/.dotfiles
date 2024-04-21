#!/bin/sh
# UB: read -a

# better to manager bookmark via browser, but that's really suck
# maybe we could filter it
PROJ_DIR=$(zoxide query -l | rofi -dmenu)
# PROJ_DIR="$(zoxide query -l |  ~/b/path-git-format/target/debug/path-git-format --filter -f '{path}' | rofi -dmenu)"
[ -z "$PROJ_DIR" ] || [ ! -e "$PROJ_DIR"/.git ] && exit 0

# gh will replace url to upstream
for remote in upstream origin; do
  git -C "$PROJ_DIR" remote get-url --no-push $remote &>/dev/null || continue
  URI="$(git -C "$PROJ_DIR" remote get-url --no-push $remote)"

  # prefer https url (when no proper mime handler)
  IFS=':' read -r -a parts <<<"$URI"
  if [[ $URI == git@github.com* ]]; then
    username_repo="${parts[1]}"
    HTTPS_URL="https://github.com/${username_repo}"
  else
    HTTPS_URL="$URI"
  fi
  xdg-open "$HTTPS_URL"
  exit
done

