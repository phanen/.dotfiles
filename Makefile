.PHONY = apply tmux

DOTFILES_DIR = $(HOME)/dotfiles

apply:
	@[[ $$PWD == "$$HOME"/dotfiles ]] && rsync -av . .. || echo "not in correct directory"

nvim-theme:
	touch ~/.config/nvim/theme

tmux:
	@mkdir -p ~/.config/tmux/plugins/
	@git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm --depth=1
