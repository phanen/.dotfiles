function pie --wrap "paru -G"
  cd ~/archriscv-packages || return
  test -z $argv[1] && return
  cd ~/src/$argv[1] || return
  git diff --no-prefix --relative | tail -n +3 >riscv64.patch
  bash -c '. ./PKGBUILD; echo -n $pkgname $pkgver-$pkgrel' | cliphist store
  cd ~/archriscv-packages || return
  git pull --ff-only upstream master:master
  git push origin master:master
  git checkout -B $argv[1] master
  mkdir -p $argv[1] && cd $argv[1]
  cp -v ~/src/$argv[1]/*.patch .
  test -s riscv64.patch || rm *.patch
end

