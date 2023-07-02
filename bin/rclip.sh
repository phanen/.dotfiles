#!/bin/bash
active_window_id=$(xdotool getactivewindow)
active_window_pid=$(xdotool getwindowpid "$active_window_id")
process=$(cat /proc/$active_window_pid/comm)
xdotool key --clearmodifiers Control_L+v
