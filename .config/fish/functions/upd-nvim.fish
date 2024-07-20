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
        git checkout master
        git pull upstream master:master
        git checkout patch
        git rebase master patch
        if set -q _flag_sync
            git push origin patch -f
            git push origin master
        end
        set -q _flag_force; or return
    end

    # set -lx CC clang
    # set -lx CXX clang++
    set -lx CMAKE_GENERATOR Ninja
    set -l cmake_build_type RelWithDebInfo
    set -q _flag_type; and set cmake_build_type $_flag_type

    if set -q _flag_host
        kitten ssh arch "fish -ic \"upd-nvim -t $cmake_build_type\""
        rsync --mkpath -avzP $_flag_host:~/b/neovim/build/{bin,lib} $src/build/
        set -q _flag_force; or return
    end

    # https://aur.archlinux.org/packages/neovim-git?O=10
    # https://gist.github.com/MawKKe/b8af6c1555f1c7aa4c2760350ed97fff
    if set -q _flag_dep
        cmake -Scmake.deps -B.deps \
            -DCMAKE_C_COMPILER=clang \
            -DUSE_BUNDLED=OFF \
            -DUSE_BUNDLED_TS_PARSERS=ON \
            --fresh
        # -DCMAKE_EXE_LINKER_FLAGS="-fuse-ld=mold" \
        # -DCMAKE_SHARED_LINKER_FLAGS="-fuse-ld=mold"
        cmake --build .deps --clean-first
        set -q _flag_force; or return
    end

    cmake -S. -Bbuild \
        -DCMAKE_BUILD_TYPE=$cmake_build_type \
        -DCMAKE_C_COMPILER=clang \
        -DENABLE_LTO=ON \
        --fresh
    # -DCMAKE_EXE_LINKER_FLAGS="-fuse-ld=mold" \
    # -DCMAKE_SHARED_LINKER_FLAGS="-fuse-ld=mold"
    cmake --build build --clean-first # --verbose

    v -es '+helptags $VIMRUNTIME/doc' +q

    # lua5.1 https://github.com/ibhagwan/fzf-lua/issues/1346
    # cmake -S cmake.deps -B .deps -G Ninja -D CMAKE_BUILD_TYPE=Release -D USE_BUNDLED_LUA=ON
    # cmake --build .deps
    # cmake -B build -G Ninja -D PREFER_LUA=ON -D CMAKE_BUILD_TYPE=Release
    # cmake --build build
    # cmake --install build --prefix your/installation/path
end
