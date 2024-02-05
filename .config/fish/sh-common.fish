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
alias cs='cd '"$XDG_STATE_HOME"'/nvim/swap/'
alias rs='exec '"$SHELL"
alias tl='tldr'
alias mx='chmod +x'
alias rx='chmod -x'
alias vn='nvim -u NONE'
alias du='dust'
alias em='emacs -nw'
alias lg='lazygit'
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
alias tp='unset http_proxy https_proxy all_proxy;'
alias zz='mkdir -p /tmp/tmp; cd /tmp/tmp; paru -G'
alias rb='extra-riscv64-build -- -d '"$HOME"'/pkg/:/var/cache/pacman/pkg'
alias rvp='git diff --no-prefix --relative | tail -n +3  > riscv64.patch'
alias rve='sudo systemd-nspawn -D ~/plct/archriscv/ --machine archriscv -a -U'
alias nvp='git diff | tee ~/.config/nvim/patches/$(basename $(pwd)).patch'
function add-key
  babelfish < ./PKGBUILD | source
  for key in $validpgpkeys
    echo 'Receiving key '"$key"'...'
    gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys "$key" || true
    gpg --keyserver hkps://keys.openpgp.org --recv-keys "$key" || true
  end
end
function gib
  cd ~/src || return 1
  test -z $argv[1] && return 1
  if test -d $argv[1]
    set fname $argv[1]
    cd $fname
  else
    paru -G $argv[1] || return 1
    set fname $argv[1]
    cd $fname
  end
  babelfish < ./PKGBUILD | source
  echo arch='('$arch')'
  for s in $source
    echo $s
  end
  for s in $_commit
    echo $s
  end
  cp ~/archriscv-packages/$fname/*.patch .
  return 0
end
function pie
  cd ~/archriscv-packages || return
  test -z $argv[1] && return
  set fname $argv[1]
  cd ~/src/$fname || return
  git diff --no-prefix --relative | tail -n +3 >riscv64.patch
  cat riscv64.patch
  babelfish < ./PKGBUILD | source
  echo -n "$fname"' '"$pkgver"'-'"$pkgrel" | xsel -ib
  cd ~/archriscv-packages || return
  git checkout master
  git pull --ff-only upstream master:master
  git push
  git checkout -b $fname || git checkout $fname
  git rebase master
  mkdir -p $fname && cd $fname
  cp ~/src/$fname/*.patch .
  test -s riscv64.patch || rm *.patch
end
