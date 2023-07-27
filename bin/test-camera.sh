#!/bin/bash

# https://wiki.archlinux.org/title/webcam_setup

# mplayer tv:// -tv driver=v4l2:width=640:height=480:device=/dev/video0 -fps 15 -vf screenshot

mpv av://v4l2:/dev/video0 --profile=low-latency --untimed
