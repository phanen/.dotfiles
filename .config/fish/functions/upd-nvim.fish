function upd-nvim
    argparse -n upd-nvim --max-args=1 \
        i/init \
        f/force \
        p/pull \
        s/sync \
        -- $argv
    or return 1

    set -l src ~/b/neovim
    if ! [ -e $src -o -d $src ]
        printf (_ "no such direcotry: %s\n") $src
        return 1
    end

    cd $src

    if set -q _flag_init
        git clone https://github.com/phanen/neovim $src
        git remote add upstream http://github.com/neovim/neovim
        git fetch
        git branch patch origin/patch
        git checkout patch
        git branch --set-upstream-to=upstream/master
        set -q _flag_force; or return 0
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
        set -q _flag_force; or return 0
    end

    make
    nvim -es '+helptags $VIMRUNTIME/doc' +q
end
