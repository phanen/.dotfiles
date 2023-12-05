#!/bin/sh

regex='(https?|ftp|file)://[-[:alnum:]\+&@#/%?=~_|!:,.;]*[-[:alnum:]\+&@#/%=~_|]'
read url
if [[ $url =~ $regex ]]
then
    notify-send "ok"
    echo $url
else
    # notify-send --urgency=critical "not valid url"
    echo -n
fi
