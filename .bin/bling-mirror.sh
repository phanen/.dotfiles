#!/bin/bash

tuna=$(curl -s https://mirrors.tuna.tsinghua.edu.cn/archlinux/lastsync)
bfsu=$(curl -s https://mirrors.bfsu.edu.cn/archlinux/lastsync)
sjtug=$(curl -s https://mirror.sjtu.edu.cn/archlinux/lastsync)
aliyun=$(curl -s https://mirrors.aliyun.com/archlinux/lastsync)
ustc=$(curl -s https://mirrors.ustc.edu.cn/archlinux/lastsync)
zju=$(curl -s https://mirrors.zju.edu.cn/archlinux/lastsync)
cqu=$(curl -s https://mirrors.cqu.edu.cn/archlinux/lastsync)
lzu=$(curl -s https://mirror.lzu.edu.cn/archlinux/lastsync)
neusoft=$(curl -s https://mirrors.neusoft.edu.cn/archlinux/lastsync)
# dgut=$(curl -s https://mirrors.dgut.edu.cn/archlinux/lastsync)
netease=$(curl -s https://mirrors.163.com/archlinux/lastsync)
tencent=$(curl -s https://mirrors.tencent.com/archlinux/lastsync)
hit=$(curl -s https://mirrors.hit.edu.cn/archlinux/lastsync)
huaweicloud=$(curl -s https://mirrors.huaweicloud.com/archlinux/lastsync)
sohu=$(curl -s https://mirrors.sohu.com/archlinux/lastsync)
opentuna=$(curl -s https://opentuna.cn/archlinux/lastsync)
pku=$(curl -s https://mirrors.pku.edu.cn/archlinux/lastsync)
nju=$(curl -s https://mirrors.nju.edu.cn/archlinux/lastsync)
njupt=$(curl -s https://mirrors.nju.edu.cn/archlinux/lastsync)

echo """
$tuna        #tuna
$bfsu        #bfsu
$sjtug       #sjtug
$aliyun      #aliyun
$ustc        #ustc
$zju         #zju
$cqu         #cqu
$lzu         #lzu
$neusoft     #neusoft
$dgut        #dgut
$netease     #netease
$tencent     #tencent
$hit         #hit
$huaweicloud #huaweicloud
$sohu        #sohu
$opentuna    #opentuna
$pku         #pku
$nju         #nju
$njupt       #njupt
"""  | sort -r
