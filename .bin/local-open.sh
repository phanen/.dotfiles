#!/usr/bin/env bash
# https://github.com/suan/local-open

if [[ -f ~/.localopenrc ]]; then
  . ~/.localopenrc
fi
# NOTE: user name must be the same
user=${LOCAL_OPEN_USER-$USER}
alt_localhost=${ALT_LOCALHOST-`hostname`}
url=$1
open_cmd=${LOCAL_OPEN_CMD-"xdg-open"}
host=${LOCAL_OPEN_HOST-"localhost"}
port=${LOCAL_OPEN_PORT-1999}

if [[ -z $SSH_CLIENT ]]; then
  if hash xdg-open &>/dev/null; then
    open_cmd=`which xdg-open`
  else
    open_cmd=`which open`
  fi
  $open_cmd "$url"
else
  if [[ "$url" == *localhost* ]]; then
    url=${url/localhost/$alt_localhost}
  elif [[ "$url" == *"127.0.0.1"* ]]; then
    url=${url/127\.0\.0\.1/$alt_localhost}
  fi
  ssh -l $user -p $port $host "$open_cmd \"$url\""
fi

