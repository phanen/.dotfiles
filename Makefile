.PHONY = apply

apply:
	rsync -av . ..

tmux:
	mkdir -p ~/.config/tmux/plugins/
	git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/
