export CHROOT=$HOME/chroot/
export CACHE_DIR=$HOME/pkg/
export USERNAME=phanen

alias rv64build="extra-riscv64-build -- -d $CACHE_DIR:/var/cache/pacman/pkg"
alias nohuprv64build="nohup extra-riscv64-build -- -d ~/pkg:/var/cache/pacman/pkg &"
alias prep="~/.bin/prepare.sh"
alias gib="~/.bin/gib.sh"

rv-patch() {
  git diff --no-prefix --relative | tail -n +3  > riscv64.patch
}
rv-ent() {
  sudo systemd-nspawn -D ./plct/archriscv/ --machine archriscv -a -U
}

