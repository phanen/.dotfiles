alias v='nvim'
alias k='pkill'
alias t='type -a'
alias y='paru'
alias s='systemctl'
alias vj='NVIM_APPNAME=nvim-test nvim'
alias ls='eza --color=auto --hyperlink'
alias la='eza -a'
alias l='eza -la'
alias lt='eza --tree'
alias df='df -h'
alias which='which -a'
alias rs='exec '"$SHELL"
alias tl='tldr'
alias mx='chmod +x'
alias rx='chmod -x'
alias vn='nvim -u NONE'
alias du='dust'
alias em='emacs -nw'
alias lg='lazygit'
alias py='python'
alias pi='sudo pacman -S'
alias pd='sudo pacman -Rns'
alias pao='pacman -Qo'
alias pfo='pacman -F'
alias pai='pacman -Qi'
alias psi='pacman -Si'
alias pal='pacman -Ql'
alias pfl='pacman -Fl'
alias pas='pacman -Qs'
alias pss='pacman -Ss'
alias yss='paru -Ss'
alias ysi='paru -Si'
alias yi='paru -S'
alias pat='pactree -lu'
alias par='pactree -r -lu'
alias pst='pactree -slu'
alias psr='pactree -r -slu'
alias vw='which.sh $VISUAL'
alias lw='which.sh exa\\ -la'
alias ldw='which.sh ldd'
alias fw='which.sh file'
alias tp='unset http_proxy https_proxy all_proxy;'
alias zz='mkdir -p /tmp/tmp; cd /tmp/tmp; paru -G'
alias rb='extra-riscv64-build -- -d ~/pkg-riscv64/:/var/cache/pacman/pkg'
alias rvp='git diff --no-prefix --relative | tail -n +3  > riscv64.patch'
alias rve='sudo systemd-nspawn -D ~/plct/archriscv/ --machine archriscv -a -U'
alias nvp='git diff | tee ~/.config/nvim/patches/$(basename $(pwd)).patch'
function gib
  cd ~/src || return
  cd $argv[1] && return
  paru -G $argv[1] || return
  cd $argv[1]
  cp -v ~/archriscv-packages/$argv[1]/*.patch .
end
function pie
  cd ~/archriscv-packages || return
  test -z $argv[1] && return
  cd ~/src/$argv[1] || return
  git diff --no-prefix --relative | tail -n +3 >riscv64.patch
  bash -c '. ./PKGBUILD; echo -n $pkgname $pkgver-$pkgrel' | cliphist store
  cd ~/archriscv-packages || return
  git pull --ff-only upstream master:master
  git push origin master:master
  git checkout -B $argv[1] master
  mkdir -p $argv[1] && cd $argv[1]
  cp -v ~/src/$argv[1]/*.patch .
  test -s riscv64.patch || rm *.patch
end
