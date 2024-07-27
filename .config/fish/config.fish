set fisher_path $__fish_user_data_dir/fisher
# priority: user > plugin > system-wide
set fish_function_path $fish_function_path[1] $fisher_path/functions $fish_function_path[2..]
set fish_complete_path fish_complete_path[1] $fisher_path/completions $fish_complete_path[2..]
for file in $fisher_path/conf.d/*.fish
    source $file
end

# note:
#   run alias will load all function
#   run `type func` will load `func`
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

    functions --copy cd old_cd


    # limit: fisher cannot used in `non-interactive` shell
    # we now not vendor fisher
    #not functions -q fisher; and _fisher_bootstrap
    source $__fish_config_dir/abbr.fish
    source $__fish_config_dir/alias.fish
    # many plugins will hijack bindings, we always override what we want here...
    source $__fish_config_dir/bind.fish


    # TODO: kitty ssh cannot be nested
    test $TERM = xterm-kitty
    and function ssh --wrap ssh
        # fix error: completion reached maximum recursion depth, possible cycle?
        # TODO: Error: The SSH kitten is meant to run inside a kitty window
        kitty +kitten ssh $argv
    end

    # eval "$(zoxide init fish)"
    #eval "$(atuin init fish)"
    # starship init fish | source
    # eval "$(starship init fish --print-full-init)"
end

# function rga-fzf
#     set RG_PREFIX 'rga --files-with-matches'
#     if test (count $argv) -gt 1
#         set RG_PREFIX "$RG_PREFIX $argv[1..-2]"
#     end
#     set -l file $file
#     set file (
#         FZF_DEFAULT_COMMAND="$RG_PREFIX '$argv[-1]'" \
#         fzf --sort \
#             --preview='test ! -z {} && \
#                 rga --pretty --context 5 {q} {}' \
#             --phony -q "$argv[-1]" \
#             --bind "change:reload:$RG_PREFIX {q}" \
#             --preview-window='50%:wrap'
#     ) && \
#     echo "opening $file" && \
#     open "$file"
# end
#
