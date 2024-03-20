function upd-nvim
  argparse -n upd-nvim --max-args=1 p/pull s/sync 't/type=' -- $argv
  set -l src ~/b/neovim
  set -lx CC clang
  set -lx CXX clang++

  if not test -d $src
    git clone https://github.com/phanen/neovim $src
    cd $src
    git remote add upstream http://github.com/neovim/neovim
    git fetch
    git branch patch origin/patch
    git checkout patch
  end

  test (pwd) != (path normalize ~/b/neovim);
  and cd $src

  if set -q _flag_pull; or set -q _flag_sync
    git pull upstream master:master
    git rebase master patch
    if set -q _flag_sync
      git push origin patch -f
      git push origin master
    end
    return
  end

  set -lx CMAKE_GENERATOR Ninja
  set -l cmake_build_type RelWithDebInfo
  set -q _flag_type; and set cmake_build_type $_flag_type

  # https://aur.archlinux.org/packages/neovim-git?O=10
  # cmake -Scmake.deps -B.deps \
  #   -DUSE_BUNDLED=OFF \
  #   -DUSE_BUNDLED_TS_PARSERS=ON
  # cmake --build .deps
  cmake -S. -Bbuild \
    -DCMAKE_BUILD_TYPE=$cmake_build_type
  cmake --build build

  v -es '+helptags $VIMRUNTIME/doc' +q
end
