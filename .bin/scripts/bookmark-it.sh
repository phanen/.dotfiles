#!/bin/sh
regex='(https?|ftp|file)://[-[:alnum:]\+&@#/%?=~_|!:,.;]*[-[:alnum:]\+&@#/%=~_|]'
filepath=~/notes/rss.txt
# read url
url="$(xsel -ob)"
if [[ $url =~ $regex ]]; then
  echo $url | LC_ALL=C sort -o $filepath - $filepath
  # only runnable in wm/de
  notify-send "link"
else
  echo $url >>~/list.txt
  notify-send "non-link"
fi
