function upd-nvim
  if not test -d ~/b/neovim
    mkdir ~/b/neovim -p
    git clone https://github.com/neovim/neovim
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
