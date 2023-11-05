.PHONY = apply nvim-theme zsh fish tmux

DOTFILES_DIR = $(HOME)/dotfiles

apply:
	@[[ $$PWD == "$$HOME"/dotfiles ]] && rsync -av . .. || echo "not in correct directory"

$(shell touch ~/.config/nvim/theme)

zsh:
	yay -S zsh-autosuggestions \
		zsh-completions \
		zsh-fast-syntax-highlighting \
		fzf-tab-git

fish:
	yay -S fifc \
		fish-fzf

font:
	yay -S nerd-fonts-cascadia-code \
		ttf-firacode-nerd \
		noto-fonts-cjk \
		gnu-free-fonts \
		awesome-terminal-fonts

tmux:
	mkdir -p ~/.config/tmux/plugins/
	git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm --depth=1
