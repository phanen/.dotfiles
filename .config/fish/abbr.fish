# sudo? maybe use alt-s...
abbr a cat
abbr c cargo
abbr d docker
abbr e nvim
abbr f cd
abbr g git
abbr h tokei
abbr i ipython
abbr j -f _make_or_just
abbr k pkill
abbr l eza -lh
abbr m mkdir -p
abbr n nvimz
abbr o echo
abbr p python
abbr s systemctl
abbr t type -a
abbr y paru

abbr type type -a
abbr tree "command eza --tree"

abbr df df -h
abbr du dust
abbr em emacs -nw
abbr fa fish_add_path -ag
abbr fl fc-list \| rg
abbr fm fc-match
abbr fn fish --no-config
abbr fs funcsave
abbr gb gh browse
abbr gr git remote -v
abbr hf hyperfine -w 5
abbr la eza -a
abbr lg lazygit
abbr ll eza -1
abbr ls eza
abbr lt eza --tree
abbr mx chmod +x
abbr rx 'chmod -x'
abbr sc sysctl
abbr sh bash
abbr ta tmux a || tmux
abbr tl tldr
abbr vj NVIM_APPNAME=nvim-test nvim
abbr wh which -a

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

abbr ch gh pr checkout

abbr pv python -m virtualenv venv
abbr pe . ./venv/bin/activate.fish

abbr ii curl -sL http://ipinfo.io

abbr kt kitty +kitten transfer

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
    if string match -q -r ^man -- $proc
        echo -l -
    else
        echo \-
    end
end

function abbr_e
    if command -q nvim >/dev/null
        echo nvim
    else
        echo vi
    end
end

abbr -p anywhere -f abbr_s -- s
abbr -p anywhere -f abbr_- -- -

abbr list 'string join \n'
abbr ju journalctl -eu

abbr luajit rlwrap luajit

# abbr pi sudo pacman -S
# abbr pd sudo pacman -Rns
# abbr pdd sudo pacman -Rd
# abbr pid sudo pacman -S --asdeps
# abbr pao pacman -Qo
# abbr pfo pacman -F
# abbr pai pacman -Qi
# abbr pal pacman -Ql
# abbr pfl pacman -Fl
# abbr pas pacman -Qs
# abbr pss pacman -Ss
# abbr yss paru -Ss
# abbr ysi paru -Si
# abbr yi paru -S
# abbr pat pactree -lu
# abbr par pactree -r -lu
# abbr pst pactree -slu
# abbr psr pactree -r -slu
