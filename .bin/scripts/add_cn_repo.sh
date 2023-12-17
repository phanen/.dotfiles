#!/bin/sh

grep archliuxncn /etc/pacman.conf 2>&1 >/dev/null && exit
cat <<- EOF >> sudo tee -a /etc/pacman.conf
[archlinuxcn]
Server = https://mirrors.ustc.edu.cn/archlinuxcn/$arch
EOF
