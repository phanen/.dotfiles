set fisher_path $__fish_user_data_dir/fisher
set -a fish_complete_path $fisher_path/completions
set -a fish_function_path $fisher_path/functions

for file in $fisher_path/conf.d/*.fish
    source $file
end

status is-interactive; and begin
    # limit: fisher cannot used in `non-interactive` shell
    # we now not vendor fisher
    #not functions -q fisher; and _fisher_bootstrap
    source $__fish_config_dir/abbr.fish
    source $__fish_config_dir/alias.fish
    # many plugins will hijack bindings, we always override what we want here...
    source $__fish_config_dir/bind.fish
    #eval "$(atuin init fish)"
    #eval "$(zoxide init fish)"
    # starship init fish | source
    # eval "$(starship init fish --print-full-init)"
end
