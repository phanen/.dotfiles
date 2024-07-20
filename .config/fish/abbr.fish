abbr c cargo
abbr d docker
abbr g git
abbr h tokei
abbr i ipython
abbr j -f _make_or_just
abbr k pkill
abbr n nvim -l
abbr o bat
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

abbr ii curl -sL http://ipinfo.io

abbr kt kitty +kitten transfer

if set -q FISH_LATEST
    # FIXME: collision with normal case...
    # sadly... that's not what we want
    # abbr -c systemctl a start
    # abbr -c systemctl o stop
    # abbr -c systemctl s status
    # abbr -c systemctl dr daemon-reload
end

function abbr_s
    set -l proc (commandline -p)
    if string match -q -r systemctl $proc
        echo status
    else
        echo systemctl
    end
end

function abbr_-
    set -l proc (commandline -p)
    if string match -q -r man $proc
        echo -l -
    else
        echo -
    end
end

# TODO: to be more useful, first we need a k-v abstract anyway...
abbr -p anywhere -f abbr_s -- s
abbr -p anywhere -f abbr_- -- -

abbr list 'string join \n'
abbr grep rg
abbr ju journalctl -eu
