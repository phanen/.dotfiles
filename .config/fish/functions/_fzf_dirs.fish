function _fzf_dirs
    # set -l src_c fd . -d 1 --type d -I
    set -l src_z zoxide query -l
    set -l src_u fd . ~/.local/share/nvim/lazy/ ~/dot/ ~/b/ -d 1 --type directory -a \| (string escape -- rg '/$' -r '')
    set -l filter (string escape -- awk '!_[$0]++')
    set -l start "{ $src_z; $src_u; } | $filter"
    fzf \
        --bind "start:reload:$start" \
        --bind "ctrl-d:execute-silent(zoxide remove {})+reload($start)"
    commandline -f repaint
end
