export CHROOT=$HOME/chroot/
export CACHE_DIR=$HOME/pkg/
export USERNAME=phanen

alias rb="extra-riscv64-build -- -d $CACHE_DIR:/var/cache/pacman/pkg"

rv-patch() {
  git diff --no-prefix --relative | tail -n +3  > riscv64.patch
}

rv-ent() {
  sudo systemd-nspawn -D ./plct/archriscv/ --machine archriscv -a -U
}

__init_rv_pkg() {
    cd ~
    mkdir src pkg
    sudo pacman -Sy --noconfirm pkgctl devtools-riscv64  # -Syu & reboot first, if necessary
    git clone git@github.com:$USERNAME/archriscv-packages.git
    cd archriscv-packages
    git remote add upstream https://github.com/felixonmars/archriscv-packages.git
}

peek() {
    . ./PKGBUILD
    echo arch="(${arch[@]})"
    for s in "${source[@]}"; do
        echo $s
    done
    for s in "${_commit[@]}"; do echo $s
    done
}

add-key() {
    . ./PKGBUILD
    for key in "${validpgpkeys[@]}"; do
        echo "Receiving key ${key}..."
        # try both servers as some keys exist one place and others another
        # we also want to always try to receive keys to pick up any update
        gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys "$key" || true
        gpg --keyserver hkps://keys.openpgp.org --recv-keys "$key" || true
    done
}

gib() {
    fname=$1

    # no arg: cd to src
    test -z $fname && cd ~/src && return

    gib 
    # pkg exist
    cd $fname && peek && return

    # pkg not exist, fetch it
    yay -G $fname || return
    cd $fname

    peek
    add-key

    # get old patch
    cp ~/archriscv-packages/$fname/*.patch .
}

pie() {
    fname=$1

    # no arg, cd to repo
    test -z $fname && cd ~/archriscv-packages && return

    # no new patch
    cd ~/src/$fname || return

    # gen patch
    rv-patch
    cat riscv64.patch
    # fetch commit info by the way
    . ./PKGBUILD
    echo -n "${fname} ${pkgver}-${pkgrel}" | xsel

    pie
    echo "Pulling from upstream (Fast-Forward Only)..."
    git checkout master
    git pull --ff-only upstream master:master
    git push
    git checkout -b "$fname" || git checkout "$fname"
    git rebase master # if branch exist, sync it first

    mkdir -p ~/archriscv-packages/"$fname"
    cd $fname

    cp ~/src/$fname/*.patch .
    test -s riscv64.patch || rm *.patch
}
