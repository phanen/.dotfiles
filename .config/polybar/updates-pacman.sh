#!/bin/sh

u=$(checkupdates 2> /dev/null | wc -l)
e=$(pacman -Qqe 2> /dev/null | wc -l)
d=$(pacman -Qqd 2> /dev/null | wc -l)
o=$(pacman -Qqdt 2> /dev/null | wc -l)

echo "$u"u "$o"o "$e"e "$d"d
