set fisher_path $__fish_user_data_dir/fisher
set fish_complete_path $fish_complete_path[1] $fisher_path/completions $fish_complete_path[2..]
set fish_function_path $fish_function_path[1] $fisher_path/functions $fish_function_path[2..]
for file in $fisher_path/conf.d/*.fish
  source $file
end

function _em
  test -z "$(string trim $(commandline))"
  and eval "$argv[1]; return"
  or eval $argv[2]
end

# fish_default_key_bindings
fzf_configure_bindings --directory=\ef --processes=\ep --git_log=\eg --history=\cr

function _ea
  test -z "$(commandline)"
  and eval "$argv[1]; return"
  or eval $argv[2]
end

bind \ce k_ce
bind \cf k_cf
bind \cg k_cg
bind \ch '_em "echo;tokei;commandline -f repaint" "_autopair_backspace"'
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
bind \r k_enter
bind \x1c "kitty +kitten show_key"

zoxide init --no-cmd fish | source
