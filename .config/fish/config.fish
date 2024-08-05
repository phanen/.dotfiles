set fisher_path $__fish_user_data_dir/fisher
# priority: user > plugin > system-wide
set fish_function_path $fish_function_path[1] $fisher_path/functions $fish_function_path[2..]
set fish_complete_path fish_complete_path[1] $fisher_path/completions $fish_complete_path[2..]
for file in $fisher_path/conf.d/*.fish
    source $file
end

# if status is-interactive
#     set _fishprompt_aid "fish"$fish_pid
#     set _fishprompt_started 0
#     # empty if running; or a numeric exit code; or CANCEL
#     set _fishprompt_postexec ""
#
#     functions -c fish_prompt _fishprompt_saved_prompt
#     set _fishprompt_prompt_count 0
#     set _fishprompt_disp_count 0
#     function _fishprompt_start --on-event fish_prompt
#         set _fishprompt_prompt_count (math $_fishprompt_prompt_count + 1)
#         # don't use post-exec, because it is called *before* omitted-newline output
#         if [ -n "$_fishprompt_postexec" ]
#             printf "\033]133;D;%s;aid=%s\007" "$_fishprompt_postexec" $_fishprompt_aid
#         end
#         printf "\033]133;A;aid=%s;cl=m\007" $_fishprompt_aid
#     end
#
#     function fish_prompt
#         set _fishprompt_disp_count (math $_fishprompt_disp_count + 1)
#         printf "\033]133;P;k=i\007%b\033]133;B\007" (string join "\n" (_fishprompt_saved_prompt))
#         set _fishprompt_started 1
#         set _fishprompt_postexec ""
#     end
#
#     function _fishprompt_preexec --on-event fish_preexec
#         if [ "$_fishprompt_started" = 1 ]
#             printf "\033]133;C;\007"
#         end
#         set _fishprompt_started 0
#     end
#
#     function _fishprompt_postexec --on-event fish_postexec
#         set _fishprompt_postexec $status
#     end
#
#     function __fishprompt_cancel --on-event fish_cancel
#         set _fishprompt_postexec CANCEL
#         _fishprompt_start
#     end
#
#     function _fishprompt_exit --on-process %self
#         if [ "$_fishprompt_started" = 1 ]
#             printf "\033]133;Z;aid=%s\007" $_fishprompt_aid
#         end
#     end
#
#     if functions -q fish_right_prompt
#         functions -c fish_right_prompt _fishprompt_saved_right_prompt
#         function fish_right_prompt
#             printf "\033]133;P;k=r\007%b\033]133;B\007" (string join "\n" (_fishprompt_saved_right_prompt))
#         end
#     end
# end

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
    # source $__fish_config_dir/bind.fish

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
