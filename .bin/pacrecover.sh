#!/usr/bin/env bash -e

. /etc/makepkg.conf

PKGCACHE=$((grep -m 1 '^CacheDir' /etc/pacman.conf || echo 'CacheDir = /var/cache/pacman/pkg') | sed 's/CacheDir = //')

pkgdirs=("$@" "$PKGDEST" "$PKGCACHE")

while read -r -a parampart; do
  pkgname1="${parampart[0]}-${parampart[1]}-*.pkg.tar.zst"
  # pkgname2="${parampart[0]}-${parampart[1]}-*.pkg.tar.xz"
  for pkgdir in ${pkgdirs[@]}; do
    pkgpath="$pkgdir"/$pkgname1
    [ -f $pkgpath ] && { echo $pkgpath; break; }
    # pkgpath="$pkgdir"/$pkgname2
    # [ -f $pkgpath ] && { echo $pkgpath; break; }
  done || echo ${parampart[0]} 1>&2
done
