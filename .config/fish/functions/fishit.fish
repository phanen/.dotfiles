function fishit
    test (count $argv) -eq 1
    or return 1

    set -l outdir "$argv[1]"
    set outdir (realpath $outdir)
    test -z $outdir
    and return 1

    set -l plugname (basename $outdir)

    rm -rv $outdir/{completions, conf.d, functions}
    mkdir -pv $outdir/{completions, conf.d, functions}

    set -l tmpfile (mktemp)
    grep -Ev '^.*#|^$' - | tee $tmpfile | source
    fish_indent -w $tmpfile

    # for each function
    for f in $(cat $tmpfile | grep ^function | cut -d' ' -f2)
        # skip handler
        functions -H | grep -q $f; and continue
        funcsave -d $outdir/functions $f
        sed -i "/^function\s*$f/,/^end/d" $tmpfile
    end
    grep -q ^complete $tmpfile
    and grep ^complete $tmpfile >$outdir/completions/$plugname
    grep -qv ^complete $tmpfile
    and grep -v ^complete $tmpfile >$outdir/conf.d/$plugname

    rm -v $tmpfile
    find -name '*.fish' -type f | xargs fish_indent -w
end
