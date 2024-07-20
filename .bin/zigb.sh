#!/bin/bash
https://github.com/ziglang/zig/issues/15048

set -e

if [ $# -ne 1 ] && [ ! -e build.zig.zon ]; then
    echo "Couldn't find build.zig.zon file, please give path to it, or change current dir to a decent zig project"
    echo "  usage: zfetch.sh [build.zig.zon]"
    exit -1
fi

do_fetch() {
    for d in `grep -o 'url *=.*' $1 | cut -d = -f 2`; do
        d=`echo $d | grep -o 'https://[^"]*'`
        if echo $d | grep '\.tar\.gz$'; then
            url=$d
        elif echo $d | grep '#[.0-9a-z]*$'; then
            url_base=`echo $d | awk -F \# '{print $1}'`
            url_base=${url_base%.git}
            url_commit=`echo $d | awk -F \# '{print $2}'`
            url="${url_base}/archive/${url_commit}.tar.gz"
        else
            echo "Ignored $d, unable to resolve it!"
            continue
        fi
        wget $url
        tarfile=${url##*/}
        hash=`zig fetch --debug-hash $tarfile | tail -n 1`
        rm $tarfile
        if [ -e ~/.cache/zig/p/$hash/build.zig.zon ]; then
            do_fetch ~/.cache/zig/p/$hash/build.zig.zon
        fi
    done

    for d in `grep -o 'path *=.*' $1 | cut -d = -f 2`; do
        path=`echo $d | awk -F \" '{print $(NF-1)}'`
        if [ -e $path/build.zig.zon ]; then
            do_fetch $path/build.zig.zon
        fi
    done
}

zonfile=$1
if [ -z "$1" ]; then
    zonfile=build.zig.zon
fi

do_fetch $zonfile

