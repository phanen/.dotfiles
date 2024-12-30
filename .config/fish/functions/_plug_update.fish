# WIP:
#   only update symlink on file add/delete
#   handle duplicate specs
#   emit event
function _plug_update -d 'a custom plug manager'
    set -l fish_plugs $__fish_config_dir/fish_plugins
    set -l plug_root $__fish_user_data_dir/plug
    mkdir -p $plug_root

    function _red
        set_color red
        echo $argv
        set_color white
    end

    test -e $fish_plugs
    and set -l plugs (string match -r -- '^[^\s]+$' <$fish_plugs)
    or begin
        _red "no plugin required"
    end

    mkdir -p $__fish_user_data_dir/vendor_{conf.d,functions.d,completions.d}/
    # cleanup dead link
    find $__fish_user_data_dir/vendor_* -xtype l -print -delete

    for plug in $plugs
        if string match '^\#' $plug # comment support
            continue
        end

        echo "$(set_color green)spec: $(set_color blue)$plug$(set_color white)"
        set -l plugin_name (string match -r -- '[^/]+$' $plug)
        set -l plugin_dir
        set -l plugin_url
        # local or remote
        if string match -qr -- '^(https|git)://' $plug # remote url
            set plugin_dir $plug_root/$plugin_name
            or begin
                _red "ignore: broken url"
                continue
            end
            set plugin_url $plug
        else # local path
            set plug (eval echo $plug) # expand tilde/env-var
            if test -d $plug # local path
                set plugin_dir $plug
            else if test -e $plug
                _red "ignore: $plug is not a directory"
                continue
            else
                _red "ignore: $plug not found"
                continue
            end
        end

        # sync only if spec is a explictly remote
        if test -n $plugin_url
            if not test -e $plugin_dir # need clone
                git clone $plugin_url $plugin_dir
                or begin
                    _red "ignore: fail to clone $plugin_url"
                    continue
                end
            else if not test -d $plugin_dir; or not test -d $plugin_dir/.git
                _red "ignore: $plugin_dir is not a git repo"
                continue
            else
                git -C $plugin_dir pull
                or begin
                    _red "ignore: fail to pull $plugin_url"
                    continue
                end
            end
        end

        for file in $plugin_dir/conf.d/*
            ln -vsf $file $__fish_user_data_dir/vendor_conf.d/
        end
        for file in $plugin_dir/functions/*
            ln -vsf $file $__fish_user_data_dir/vendor_functions.d/
        end
        for file in $plugin_dir/completions/*
            ln -vsf $file $__fish_user_data_dir/vendor_completions.d/
        end
    end

    functions -e _red
end
