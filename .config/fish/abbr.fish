abbr -a c cargo
abbr -a g git
abbr -a h tokei
abbr -a i ipython
abbr -a j --function _make_or_just
abbr -a k pkill
abbr -a o cat
abbr -a p python
abbr -a s systemctl
abbr -a y paru

abbr -a du dust
abbr -a em emacs -nw
abbr -a fs funcsave
abbr -a gb gh browse
abbr -a gr git remote -v
abbr -a hf hyperfine --warmup 5
abbr -a lg lazygit
abbr -a mx chmod +x
abbr -a rx chmod -x
abbr -a ta tmux a || tmux
abbr -a vj NVIM_APPNAME=nvim-test nvim
abbr -a vk VIMRUNTIME=~/b/neovim/runtime ~/b/neovim/build/bin/nvim
abbr -a ze zoxide edit

abbr -a rb extra-riscv64-build -- -d ~/pkg-riscv64/:/var/cache/pacman/pkg
abbr -a rvp git diff --no-prefix --relative \| tail -n +3 \> riscv64.patch
abbr -a rve sudo systemd-nspawn -D ~/plct/archriscv/ --machine archriscv -a -U
abbr -a tp unset http_proxy https_proxy all_proxy
abbr -a pa xsel -ob \| patch -Np1 -i -

abbr -a nvp git diff \| tee ~/.config/nvim/patches/\(basename \(pwd\)\).patch
abbr -a pc 'comm -23 (pacman -Qqt | sort | psub) (begin pacman -Qqg xorg; echo base; end | sort -u | psub)'
abbr -a video ffmpeg -f x11grab -i \$DISPLAY -framerate 25 -c:v libx264 /tmp/tmp/showcase.mp4

abbr lu v -l
abbr cmd command
abbr gi gh repo create --source . --push
abbr gd lazygit -p '~'
abbr gn lazygit -p '~/notes'
