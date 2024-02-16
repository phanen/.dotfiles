#!/bin/sh
DT=${@:-"1 day ago"}
GDT=$(date -d "$DT" --rfc-2822)
LC_ALL=C GIT_COMMITTER_DATE="$GDT" git commit --amend --no-edit --allow-empty-message --date "$GDT"
