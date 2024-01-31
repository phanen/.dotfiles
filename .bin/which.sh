#!/bin/sh
which $2 1>/dev/null 2>&1 || exit
$1 $(which $2 | head -1)
