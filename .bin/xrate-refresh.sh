#!/usr/bin/env bash

# https://unix.stackexchange.com/questions/121858/how-can-i-set-repeat-rate-of-usb-keyboard-with-udev
(
    sleep 1

    DISPLAY=":0.0"
    # hack
    XAUTHORITY="/home/$(ls /home/ | head -n1)/.Xauthority"
    export DISPLAY XAUTHORITY
    xset r rate 145 85
) &
