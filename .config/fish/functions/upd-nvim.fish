function upd-nvim
  argparse -n upd-nvim --max-args=1 p/pull s/sync 't/type=' -- $argv
  set -l git git -C ~/b/neovim
  set -l make make -C ~/b/neovim
  if not test -d ~/b/neovim
      git clone https://github.com/phanen/neovim ~/b/neovim
      $git remote add upstream http://github.com/neovim/neovim
      $git fetch
      $git branch patch origin/patch
  end
  if set -q _flag_pull; or set -q _flag_sync
      $git pull upstream master:master
      $git rebase master patch
      if set -q _flag_sync
          $git push origin patch -f
          $git push origin master
      end
      return
  end
  set -l cmake_build_type RelWithDebInfo
  set -q _flag_type; and set cmake_build_type $_flag_type
  $git checkout patch
  CC=clang CXX=clang++ $make CMAKE_BUILD_TYPE=RelWithDebInfo
  # rm -rf ~/b/neovim/build
  # CC=clang CXX=clang++ cmake \
  #     -B ~/b/neovim/build \
  #     -S ~/b/neovim \
  #     -GNinja \
  #     -DCMAKE_BUILD_TYPE=$cmake_build_type
  # ninja -C ~/b/neovim/build -j0
  v -es '+helptags $VIMRUNTIME/doc' +q
end

