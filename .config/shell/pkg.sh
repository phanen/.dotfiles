export CHROOT=$HOME/chroot/
export CACHE_DIR=$HOME/pkg/
export USERNAME=phanen

alias rb="extra-riscv64-build -- -d $CACHE_DIR:/var/cache/pacman/pkg"
alias crb="extra-riscv64-build -c -- -d $CACHE_DIR:/var/cache/pacman/pkg"
alias xb="extra-x86_64-build -- -d $HOME/xpkg:/var/cache/pacman/pkg"
alias cxb="extra-x86_64-build -c -- -d $HOME/xpkg:/var/cache/pacman/pkg"
alias lb="/bin/ls /var/lib/archbuild/extra-riscv64/*/build"

m() { mkdir -p "$1" && cd "$1"; }
alias zz="m /tmp/tmp; paru -G"

rv-patch() {
    rm -v riscv64.patch
    git diff --no-prefix --relative | tail -n +3  > riscv64.patch
}

rv-ent() {
    sudo systemd-nspawn -D ~/plct/archriscv/ --machine archriscv -a -U
}

upd-keyring() {
    sudo arch-chroot /var/lib/archbuild/extra-riscv64/root pacman -Syu
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
    cd ~/src || return 1
    [[ -z $1 ]] && return 1
    if [[ -d $1 ]]; then
        fname=$1
        cd $fname
    else
        yay -G $1 || return 1
        # TODO: pkgname
        # out=$(paru -G $1) || return 1
        # fname=$(echo $out | awk '{print $NF}')
        fname=$1
        cd $fname
        # add-key
    fi
    peek
    cp ~/archriscv-packages/$fname/*.patch .
    return 0
}

pie() {
    cd ~/archriscv-packages || return
    [[ -z $1 ]] && return

    # update patch
    fname=$1
    cd ~/src/$fname || return
    rv-patch && cat riscv64.patch
    . ./PKGBUILD
    echo -n "${fname} ${pkgver}-${pkgrel}" | xsel

    # prepare for commit
    cd ~/archriscv-packages || return
    git checkout master
    git pull --ff-only upstream master:master
    git checkout -b $fname || git checkout $fname
    git rebase master
    m $fname
    cp ~/src/$fname/*.patch .
    test -s riscv64.patch || rm *.patch
}

find-pkg() {
    ag -l $1 | xargs -I {} sh -c 'git log -1 --pretty="format:%ci" {} && echo \ {}'
}

baklog() {
    find . -name "*.log" | xargs -I{} cp {} {}1.log
}
