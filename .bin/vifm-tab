#!/bin/sh

if [ -n "$*" ]; then
	if [ "$1" = . ]; then
		# Browsers are passing . as an argument and setting PWD for dir path
		cmd="tabnew | cd \"$PWD\""
	else
		cmd="tabnew | cd \"$*\""
	fi
else
	cmd=redraw
fi

if [ -n "$(vifm --server-list)" ]; then
	vifm --server-name vifm --remote -c "$cmd"
else
	if [ -t 2 ]; then
		# When you call vifm-tab from terminal this will set terminal instance
		# to 'vifm' so you can assign window rule in your wm
		xdotool getactivewindow set_window --classname vifm &
		vifm -c "$cmd"
	else
		# You can adjust this to your terminal and shell:
		alacritty --class vifm -e sh -c "vifm -c '$cmd'; zsh" >/dev/null 2>&1 &
	fi
fi
