# TODO(up): fish tsjoin
# TODO(up): fish_indent: ignore start
# TODO(up): better expand on string?
# see variable-as-command: https://github.com/fish-shell/fish-shell/pull/10249
# but this is impossible(expanded only once): set __z_db_query zoxide query --exclude "(eval \"$__z_pwd\")"
# e.g. 'ls' -> ok, 'ls (pwd)' -> not ok
# although we can use common eval, function...

# starup: conf.d -> config.fish -> fish_user_key_bindings.fish
# WIP(more info): https://fishshell.com/docs/current/language.html#configuration
# * fish.rs -> config.fish (data -> sysconf -> config_dir)
# * `/usr/share/fish/config.fish`: user >admin >extra (e.g. vendors) >fish

# about function
#   masking (like `:runtime **/*.fish` in vim...), apply to `functions`/`completions`
#   run alias will load all function
#   run `type func` will load `func`

set fisher_path $__fish_user_data_dir/fisher

# priority: user > plugin > system-wide
set fish_function_path $fish_function_path[1] $fisher_path/functions $fish_function_path[2..]
set fish_complete_path fish_complete_path[1] $fisher_path/completions $fish_complete_path[2..]
for file in $fisher_path/conf.d/*.fish
    source $file
end

# FIXME(unknown?):
# _ 'printf only no output'
# echo 'but with echo thing work well'
# ON-VARIBALE

status is-interactive; and begin
    string match -rq '(?<FISH_SEMVER>\d+\.\d+\.\d+)-?(?<FISH_GITVER>.*)' $FISH_VERSION

    # semver $FISH_VERSION -r ">=3.7.1" -p
    if ver_test $FISH_SEMVER -ge 3.8.0
        or begin
            # FISH_GITVER is always set here, check if it's empty
            ver_test $FISH_SEMVER -eq 3.7.1; and test -n $FISH_GITVER
        end
        set FISH_LATEST
    end >/dev/null

    # abbr f cd
    # alias cd z

    # limit: fisher cannot used in `non-interactive` shell
    # we now not vendor fisher
    #not functions -q fisher; and _fisher_bootstrap
    source $__fish_config_dir/abbr.fish
    source $__fish_config_dir/alias.fish
end
