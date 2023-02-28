#!/bin/sh


case "$1" in 
  *.bmp) feh "$1";;
  *) highlight -O ansi "$1";;
esac
