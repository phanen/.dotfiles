source ~/.shellrc

set fisher_path $__fish_user_data_dir/fisher
set fish_complete_path $fish_complete_path[1] $fisher_path/completions $fish_complete_path[2..]
set fish_function_path $fish_function_path[1] $fisher_path/functions $fish_function_path[2..]
for file in $fisher_path/conf.d/*.fish
  source $file
end

abbr -a c cargo
abbr -a cl printf "\e[H\e[3J"
abbr -a g git
abbr -a p patch -Np1 -i -
abbr -a rm \ rm
abbr -a ta tmux a || tmux
abbr -a h tokei

function gib
  cd ~/src || return
  cd $argv[1] && return
  paru -G $argv[1] || return
  cd $argv[1]
  cp -v ~/archriscv-packages/$argv[1]/*.patch .
end

function pie
  cd ~/archriscv-packages || return
  test -z $argv[1] && return
  cd ~/src/$argv[1] || return
  git diff --no-prefix --relative | tail -n +3 >riscv64.patch
  bash -c '. ./PKGBUILD; echo -n $pkgname $pkgver-$pkgrel' | cliphist store
  cd ~/archriscv-packages || return
  git pull --ff-only upstream master:master
  git push origin master:master
  git checkout -B $argv[1] master
  mkdir -p $argv[1] && cd $argv[1]
  cp -v ~/src/$argv[1]/*.patch .
  test -s riscv64.patch || rm *.patch
end

# FIXME: standard way to redraw fish prompt
function if_empty
  test -z (string trim (commandline))
  and eval "$argv[1]; return"
  or eval $argv[2]
end

# TODO: generalized -> predicate and a or b
function ctrl_s
  set -l line (commandline)
  string match -r "^https?://git.+" $line &>/dev/null
  and commandline -r ""
  and eval "git clone $line; return"

  string match -r "^gib (.+)" $line &>/dev/null
  and eval $line
  and nvim +args\ % PKGBUILD riscv64.patch
  and return
  nvim
end

function repeat_cmd
  set -l lastline $history[1]
  test -z (string trim (commandline))
  and commandline -r $lastline
  commandline -f execute
end

set -Ux FZF_DEFAULT_OPTS "
  --layout=reverse
  --height=90%
  --prompt='~ ' --pointer='▶' --marker='✓'
  --multi
  --bind=';:toggle-preview'
  --color='hl:148,hl+:154,pointer:032,marker:010,bg+:237,gutter:008'
"
# fish_hybrid_key_bindings
fish_default_key_bindings
fzf_configure_bindings --directory=\ef --processes=\ep --git_log=\eg --history=\cr
set -Ux fifc_editor nvim
set -U fifc_keybinding \ci
bind \cd delete-or-exit
bind \ce 'if_empty "zi;fish_prompt" "commandline -f end-of-line"'
bind \cg 'if_empty yazi yazi'
bind \cj nextd-or-forward-word
bind \cl kill-bigword
bind \co prevd-or-backward-word
bind \cq 'if_empty lazygit fish_clipboard_copy'
bind \cs ctrl_s
bind \ct repeat_cmd
bind \e\; 'htop'
bind \ei 'tmux a &>/dev/null || tmux &>/dev/null || tmux det'
bind \el clear
bind \er 'exec fish'
bind \ew 'fish_key_reader -c'
# TODO: <c-a> in tmux should work as prefix
# TODO: <c-u> cut job part
# only if cmdline is empty or it has been in the begin

set -U fish_greeting
zoxide init fish | source
# starship init fish --print-full-init | source
# if status is-login && test -z "$TMUX" && test -n "$SSH_TTY"
#     exec sh -c 'tmux a || tmux'
# end
