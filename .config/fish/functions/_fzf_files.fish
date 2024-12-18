function _fzf_files
    set -l delimiter \xe2\x80\x82

    set -l src fd
    set -l src_noignore fd -d 1 -I -H
    set src_noignore (string escape -- $src_noignore)

    set -l fzf fzf \
        --ansi \
        --delimiter $delimiter \
        --nth=2 \
        --bind "ctrl-g:reload($src_noignore)"

    # $src | ifd.sh | $fzf | string split -f 2 $delimiter
    $src | file_web_devicon | $fzf | string split -f 2 $delimiter
    commandline -f repaint
end
