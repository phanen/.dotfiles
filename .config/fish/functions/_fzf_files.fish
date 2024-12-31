function _fzf_files
    set -l delimiter \xe2\x80\x82
    set -l src fd --color=always
    set -l src_ni fd -I -H --color=always
    set -l filter file_web_devicon

    command -q $filter
    and set -a src \| $filter
    and set -a src_ni \| $filter

    set -l fzf fzf \
        --ansi \
        --bind "start:reload:$src" \
        --bind "ctrl-g:reload:$src_ni"

    $fzf | string split -f 2 $delimiter
    commandline -f repaint
end
