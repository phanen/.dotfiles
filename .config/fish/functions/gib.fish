function gib --wrap "paru -S"
  cd ~/src || return
  cd $argv[1] && return
  paru -G $argv[1] || return
  cd $argv[1]
  cp -v ~/archriscv-packages/$argv[1]/*.patch .
end
