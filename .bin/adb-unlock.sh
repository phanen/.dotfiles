#!/bin/bash

adb shell input keyevent KEYCODE_WAKEUP
sleep 1
adb shell input swipe 500 1000 500 200
adb shell input tap 250 1080
adb shell input tap 250 1360
adb shell input tap 550 1080
adb shell input tap 550 1360
adb shell input tap 820 1880
