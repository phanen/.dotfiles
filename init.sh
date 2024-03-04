#!/bin/bash
# user local config
sudo pacman -S --noconfirm rsync
rsync -avP ~/.dotfiles/ ~/
# TODO: private config

# TODO: system-wide config, stow
# pacman -Qii | awk '/^MODIFIED/ { print $2 }'

sudo pacman -Sy
sudo pacman -S --noconfirm archlinuxcn-keyring paru

sudo pacman -S --noconfirm zoxide exa lazygit ripgrep
# set X11Forwarding yes in /etc/ssh/sshd_config then restart sshd daemon
sudo pacman -S --noconfirm xsel xauth

sudo pacman -S --noconfirm fish
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
fisher update

sudo pacman -S --noconfirm tmux
mkdir -p ~/.config/tmux/plugins/
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm --depth=1

sudo pacman -S --needed nerd-fonts-cascadia-code noto-fonts-cjk gnu-free-fonts awesome-terminal-fonts

paru -S --noconfirm kmonad-git
