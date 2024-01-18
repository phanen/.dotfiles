apply:
	rsync -av ~/.dotfiles ~/

cnrepo:
	~/.bin/scripts/add_cn_repo.sh

# manual add cn repo, or scp /etc/pacman.conf
dep: clipboard tmux fish font
	yay -S zoxide exa lazygit tmux ripgrep

# set X11Forwarding yes in /etc/ssh/sshd_config then restart sshd daemon
clipboard:
	yay -S xsel xauth

zsh:
	yay -S --needed \
		zsh \
		zsh-autosuggestions \
		zsh-completions \
		zsh-fast-syntax-highlighting \
		fzf-tab-git

fish:
	yay -S --needed \
		fish \
		fish-fifc \
		fish-fzf
	~/.bin/sh2fish.sh

font:
	@yay -S --needed \
		nerd-fonts-cascadia-code \
		ttf-firacode-nerd \
		noto-fonts-cjk \
		gnu-free-fonts \
		awesome-terminal-fonts

tmux:
	mkdir -p ~/.config/tmux/plugins/
	git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm --depth=1
