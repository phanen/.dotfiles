#!/bin/sh
regex='(https?|ftp|file)://[-[:alnum:]\+&@#/%?=~_|!:,.;]*[-[:alnum:]\+&@#/%=~_|]'
filepath=$1
read url
if [[ $url =~ $regex ]]
then
    echo $url | LC_ALL=C sort -o $filepath - $filepath
    # only runnable in wm/de
    notify-send "link bookmarked"
fi
