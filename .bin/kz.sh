#!/bin/bash

pkill -x kmonad
pkill -x kanata

kanata >/dev/null &
disown
