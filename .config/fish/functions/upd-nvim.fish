function upd-nvim
  argparse -n upd-nvim --max-args=1 \
    b/bootstrap \
    d/dep \
    f/force \
    h/host= \
    p/pull \
    s/sync \
    t/type= \
    -- $argv
  or return

  set -l src ~/b/neovim
  mkdir -p $src; and cd $src; or return

  if set -q _flag_bootstrap
    git clone https://github.com/phanen/neovim $src
    git remote add upstream http://github.com/neovim/neovim
    git fetch
    git branch patch origin/patch
    git checkout patch
    set -q _flag_force; or return
  end

  if set -q _flag_pull; or set -q _flag_sync
    git pull upstream master:master
    git rebase master patch
    if set -q _flag_sync
      git push origin patch -f
      git push origin master
    end
    set -q _flag_force; or return
  end

  set -lx CC clang
  set -lx CXX clang++
  set -lx CMAKE_GENERATOR Ninja
  set -l cmake_build_type RelWithDebInfo
  set -q _flag_type; and set cmake_build_type $_flag_type

  if set -q _flag_host
    kitten ssh arch "fish -ic \"upd-nvim -t $cmake_build_type\""
    rsync --mkpath -avzP $_flag_host:~/b/neovim/build/{bin,lib} $src/build/
    set -q _flag_force; or return
  end

  # https://aur.archlinux.org/packages/neovim-git?O=10
  if set -q _flag_dep
    cmake -Scmake.deps -B.deps \
      -DUSE_BUNDLED=OFF \
      -DUSE_BUNDLED_TS_PARSERS=ON
    cmake --build .deps
    set -q _flag_force; or return
  end

  cmake -S. -Bbuild \
    -DCMAKE_BUILD_TYPE=$cmake_build_type
  cmake --build build

  v -es '+helptags $VIMRUNTIME/doc' +q
end
