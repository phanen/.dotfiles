#/bin/sh
tmpdir=/tmp/pkg
rm -rfv $tmpdir
mkdir -p $tmpdir
ln -s /var/lib/pacman/sync/*.db $tmpdir
ln -s /var/lib/pacman/sync/*.files $tmpdir
ln -s /var/cache/pacman/pkg/* $tmpdir
python -m http.server -d /tmp/pkg
