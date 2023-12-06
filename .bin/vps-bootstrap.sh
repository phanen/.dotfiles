#!/bin/bash

# warning: this script is not runnable
# it's just not possible to run all cmd in one machine...

machine="????"
username="alice"
passwd="bootstrap" # reset it here, maybe it should be read from stdin...
sshhostname="alice"
ip="????"

if [[ macine == "" ]]; then
# NOTE: vps
# exec after login in vps as root
# after the following done, manually reboot via web console
# re-login from vnc, root passwd may not change
wget https://felixc.at/vps2arch
chmod +x vps2arch
./vps2arch
usermod -m $username --password $(openssl passwd -6 "$password") $username
usermod -aG wheel $username
cat <<EOF | tee -a /etc/visudo
## Uncomment to allow members of group wheel to execute any command
%wheel ALL=(ALL:ALL) ALL
## Same thing without a password
%wheel ALL=(ALL:ALL) NOPASSWD: ALL
EOF
reflector --sort rate --save /etc/pacman.d/mirrorlist --country China
pacman -Syu base-devel neovim git rsync fish
ln -sf /bin/nvim /bin/vi
fi

if [[ machine == "host" ]]; then
# systemd should have start sshd
cat <<EOF
Host $hostname
  Hostname $ip
  user $username
  Port 22
EOF
# copy the id, but you may have many machine...
ssh-copy-id ali
# enable archlinuxcn...
scp /etc/pacman.conf $hostname:/etc/pacman.conf
ssh ali
fi

# other chores to be script out, or do it manually...
# but it's fucking boring, if i have 10 vps, why not migrate to nixos...
# sure, i don't have... so let's think what we should do next...
# - disable passwd login
# - chsh to fish
# - install aur-packages (yay, babelfish...)
# - gh auth login (generate ssh-key, upload to github...)
# - clipboard share via xauth...
