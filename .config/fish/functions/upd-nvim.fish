function upd-nvim
  argparse -n upd-nvim --max-args=1 p/pull -- $argv
  if not test -d ~/b/neovim
    git clone https://github.com/phanen/neovim ~/b/neovim
    git remote add upstream http://github.com/neovim/neovim
    git branch r upstream/master
  end
  if set -q _flag_pull
    git pull upstream master:r
    git rebase r master
    return
  end
  rm -rf ~/b/neovim/build
  CC=clang CXX=clang++ cmake \
    -B ~/b/neovim/build \
    -S ~/b/neovim \
    -GNinja \
    -DCMAKE_BUILD_TYPE=Release
  ninja -C ~/b/neovim/build -j0
  v -es '+helptags $VIMRUNTIME/doc' +q
end
