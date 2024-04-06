set fisher_path $__fish_user_data_dir/fisher
set -a fish_complete_path $fisher_path/completions
set -a fish_function_path $fisher_path/functions

source $__fish_config_dir/fifc.fish

status is-interactive; or exit

if not functions -q fisher
  set -l t (mktemp)
  cp $__fish_config_dir/fish_plugins $t
  curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
  and fisher update >/dev/null
  mv $t $__fish_config_dir/fish_plugins
end
for file in $fisher_path/conf.d/*.fish
  source $file
end

function _em
  test -z "$(string trim -- $(commandline))"
  and eval "$argv[1]; return"
  or eval $argv[2]
end

function _ea
  test -z "$(commandline)"
  and eval "$argv[1]; return"
  or eval $argv[2]
end

# NOTE: many plugins will hijack bindings, we always override what we want here...
bind \ce k_ce
bind \cf k_cf
bind \cg k_cg
bind \ch '_ea "echo;tokei;commandline -f repaint" "_autopair_backspace"'
bind \cj nextd-or-forward-word
bind \cl '_em "cl;commandline -f repaint" "commandline -f kill-bigword"'
bind \co prevd-or-backward-word
bind \cq '_em "lazygit;commandline -f repaint" fish_clipboard_copy'
bind \cs k_cs
bind \ct k_ct
bind \cu '_ea "htop;commandline -f repaint" "commandline -f backward-kill-line"'
bind \cw '_ea "echo;ls;commandline -f repaint" "commandline -f backward-kill-path-component"'
bind \e\[47\;5u undo
bind \e\; 'htop;commandline -f repaint'
bind \ei 'tmux a &>/dev/null || tmux &>/dev/null || tmux det'
bind \el clear-screen
bind \er 'exec fish'
bind \ew 'fish_key_reader -c'
bind -k nul 'kitten @ action kitty_scrollback_nvim'
bind \r k_enter
bind \t '_fifc'
bind \x1c "exec fish"

# and fzf_configure_bindings --directory=\ef --processes=\ep --git_log=\eg --history=\cr
# zoxide init --no-cmd fish | source
# starship init --print-full-init fish | source
