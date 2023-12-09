.PHONY = apply nvim-theme zsh fish tmux

DOTFILES_DIR = ${HOME}/dotfiles

$(shell mkdir -p ~/notes)

apply:
	@[[ $$PWD == "$$HOME"/dotfiles ]] && rsync -av . .. || echo "not in correct directory"

$(shell touch ~/.config/nvim/theme)

# manual add cn repo, or scp /etc/pacman.conf

zsh:
	@yay -S --needed zsh-autosuggestions \
		zsh-completions \
		zsh-fast-syntax-highlighting \
		fzf-tab-git

fish:
	@yay -S --needed fish-fifc \
		fish-fzf \
		babelfish-fish
	# flatten bash then translate it into fish
	@~/.bin/sh2fish.sh

font:
	@yay -S --needed nerd-fonts-cascadia-code \
		ttf-firacode-nerd \
		noto-fonts-cjk \
		gnu-free-fonts \
		awesome-terminal-fonts

# set X11Forwarding yes in /etc/ssh/sshd_config then restart sshd daemon
clipboard:
	@yay -S xsel xauth

dep:
	@yay -S zoxide exa lazygit

tmux:
	mkdir -p ~/.config/tmux/plugins/
	git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm --depth=1
