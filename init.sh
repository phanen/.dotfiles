#!/bin/bash
# user local config
sudo pacman -Syu --noconfirm rsync
rsync -avP ~/.dotfiles/ ~/
# TODO: private config

# TODO: system-wide config, stow
# pacman -Qii | awk '/^MODIFIED/ { print $2 }'

sudo pacman -Sy
sudo pacman -S --noconfirm \
  archlinuxcn-keyring paru \
  zoxide exa lazygit ripgrep \
  xsel xauth
# set X11Forwarding yes in /etc/ssh/sshd_config then restart sshd daemon

sudo pacman -S --noconfirm fish
fish -c 'fisher update'

sudo pacman -S --noconfirm tmux
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm --depth=1

sudo pacman -S --needed nerd-fonts-cascadia-code noto-fonts-cjk gnu-free-fonts awesome-terminal-fonts

paru -S --noconfirm kmonad-git
