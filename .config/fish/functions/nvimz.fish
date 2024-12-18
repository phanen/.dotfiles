function _find_nvim
    set -q XDG_CONFIG_HOME; or set -l XDG_CONFIG_HOME ~/.config
    set -l getrc_cmd '$(test -f $XDG_CONFIG_HOME/{}/init.vim && echo $XDG_CONFIG_HOME/{}/init.vim || echo $XDG_CONFIG_HOME/{}/init.lua)'

    fd 'init.(vim|lua)' $XDG_CONFIG_HOME -I -d 2 -L --prune -x basename {//} \
        | uniq \
        | rg -v '^nvim$' \
        | fzf -1 -0 \
        --preview "bat -f $getrc_cmd" \
        --bind "ctrl-s:execute(nvim $getrc_cmd)" \
        --bind "ctrl-x:execute(rm -rf ~/.local/{share,state}/{})"
end

function nvimz --wrap nvim
    set -l NVIM_APPNAME (_find_nvim)
    test -n "$NVIM_APPNAME"; and NVIM_APPNAME=$NVIM_APPNAME nvim $argv
    true
end
