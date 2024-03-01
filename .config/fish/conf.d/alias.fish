status is-interactive; or exit

function alias
  set -l wraps --wraps (string escape -- $argv[2])
  eval "function $argv[1] $wraps; $argv[2] \$argv; end"
end

alias f __zoxide_z
alias l "eza -a1"
alias s "systemctl"
alias t "type -a"

alias df "command df -h"
alias la "eza -a"
alias ls "eza --color=auto --hyperlink"
alias lt "eza --tree"
alias tl tldr
alias vn "nvim -u NONE"
alias fn "fish --no-config"
alias wh which -a

alias pi 'sudo pacman -S'
alias pd 'sudo pacman -Rns'
alias pa 'sudo pacman -S --asdeps'
alias pao 'pacman -Qo'
alias pfo 'pacman -F'
alias pai 'pacman -Qi'
alias psi 'pacman -Si'
alias pal 'pacman -Ql'
alias pfl 'pacman -Fl'
alias pas 'pacman -Qs'
alias pss 'pacman -Ss'
alias yss 'paru -Ss'
alias ysi 'paru -Si'
alias yi 'paru -S'
alias pat 'pactree -lu'
alias par 'pactree -r -lu'
alias pst 'pactree -slu'
alias psr 'pactree -r -slu'

function vw
  if command -q $argv
    v (command -v $argv)
  else if functions -q $argv
    funced $argv
  end
end

function lw
  if command -q $argv
    exa -la (command -v $argv)
  end
end

function fw
  if command -q $argv
    file (command -v $argv)
  end
end

function ldw
  if command -q $argv
    ldd (command -v $argv)
  end
end

function e
  # https://www.reddit.com/r/bash/comments/13rqfjd/detecting_chinese_characters_using_grep
  # https://github.com/fish-shell/fish-shell/issues/3847
  # | tr -d "\n"
  if echo "$argv" | grep -q -P '\p{Script=Han}'
    trans zh:en -- "$argv"
  else
    trans en:zh -- "$argv"
  end
end

function v
  if test -f ~/b/neovim/build/bin/nvim
    VIMRUNTIME=~/b/neovim/runtime ~/b/neovim/build/bin/nvim $argv
  else
    nvim $argv
  end
end

function po --wrap 'pacman -Qo'
  pacman -Qo $argv || pacman -F $argv
end

function psi
  pacman -Qi $argv || pacman -Si $argv
end

function __make_or_just
  if command -q just; and string match -iqr -- "justfile" (pwd)/*
    echo "just"
  else
    echo "make"
  end
end

abbr -a c cargo
abbr -a g git
abbr -a h tokei
abbr -a i ipython
abbr -a j --function __make_or_just
abbr -a k pkill
abbr -a o cat
abbr -a p python
abbr -a y paru

abbr -a du dust
abbr -a em emacs -nw
abbr -a fe funced
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

abbr -a rb extra-riscv64-build -- -d ~/pkg-riscv64/:/var/cache/pacman/pkg
abbr -a rvp git diff --no-prefix --relative \| tail -n +3  \> riscv64.patch
abbr -a rve sudo systemd-nspawn -D ~/plct/archriscv/ --machine archriscv -a -U
abbr -a tp unset http_proxy https_proxy all_proxy;
abbr -a pat patch -Np1 -i -

abbr -a nvp git diff \| tee ~/.config/nvim/patches/\(basename \(pwd\)\).patch
abbr -a pc 'comm -23 (pacman -Qqt | sort | psub) (begin pacman -Qqg xorg; echo base; end | sort -u | psub)'
