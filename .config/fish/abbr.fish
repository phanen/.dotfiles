abbr c cargo
abbr d docker
abbr g git
abbr h tokei
abbr i ipython
abbr j --function _make_or_just
abbr k pkill
abbr n nvim -l
abbr o cat
abbr p python
abbr s systemctl
abbr y paru

abbr du dust
abbr em emacs -nw
abbr fa fish_add_path -ag
abbr fl fc-list \| rg
abbr fm fc-match
abbr fn fish --no-config
abbr fs funcsave
abbr gb gh browse
abbr gr git remote -v
abbr hf hyperfine --warmup 5
abbr lg lazygit
abbr mx chmod +x
abbr sc sysctl
abbr sh bash
abbr ta tmux a || tmux
abbr vj NVIM_APPNAME=nvim-test nvim
abbr vk VIMRUNTIME=~/b/neovim/runtime ~/b/neovim/build/bin/nvim
abbr vm v --cmd 'lua vim.go.loadplugins = false'
abbr vn nvim -u NONE
abbr ze zoxide edit

abbr pa xsel -ob \| patch -Np1 -i -
abbr rb extra-riscv64-build -- -d ~/pkg-riscv64/:/var/cache/pacman/pkg
abbr rve sudo systemd-nspawn -D ~/plct/archriscv/ --machine archriscv -a -U
abbr rvp git diff --no-prefix --relative \| tail -n +3 \> riscv64.patch
abbr tp unset http_proxy https_proxy all_proxy
abbr pdz 'pd (comm -23 (pacman -Qqt | sort | psub) (begin pacman -Qqg xorg; echo base; end | sort -u | psub) | fzf)'

abbr nvp git diff \| tee ~/.config/nvim/patches/\(basename \(pwd\)\).patch
abbr pc 'comm -23 (pacman -Qqt | sort | psub) (begin pacman -Qqg xorg; echo base; end | sort -u | psub)'
abbr video ffmpeg -f x11grab -i \$DISPLAY -framerate 25 -c:v libx264 /tmp/tmp/showcase.mp4

abbr gi gh repo create --source . --push
abbr ge gh copilot explain
abbr gs gh copilot suggest -t shell

abbr grm git rm --cached

abbr ghg git rev-list --all \| GIT_PAGER=cat xargs git grep

abbr pv python -m virtualenv venv
abbr pe . ./venv/bin/activate.fish


# TODO(upstream): subcommand completion
abbr sdr systemctl daemon-reload
