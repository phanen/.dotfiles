function fishit
  # TODO: fishify https://github.com/fish-shell/fish-shell/issues/6520

  test (count $argv) -le 1
  or return 1

  set -l t1 (mktemp)
  cat > $t1
  or return 1

  set -l outdir
  if test -z "$argv"
    set outdir "$(pwd)"
  else
    set outdir "$argv"
  end
  set -l plugname (basename (realpath $outdir))

  rm -rv $outdir/{completions, conf.d, functions}
  mkdir -pv $outdir/{completions, conf.d, functions}

  set -l t2 (mktemp)
  grep -Ev '^.*#|^$' -- $t1 > $t2
  source $t2
  or return 1

  for f in $(cat $t2 | grep ^function | cut -d' ' -f2)
    functions -H | grep -q $f; and continue
    funcsave -d $outdir/functions $f
    sed -i "/^function\s*$f/,/^end/d" $t2
  end

  grep -q ^complete $t2
  and grep ^complete $t2 > $outdir/completions/$plugname

  grep -qv ^complete $t2
  and grep -v ^complete $t2 > $outdir/conf.d/$plugname

  rm -v $t1
  rm -v $t2
end