source ~/.config/fish/sh-common.fish

abbr -a c cargo
abbr -a cl 'printf "\e[H\e[3J"'
abbr -a gc git clone
abbr -a g git
abbr -a gp git pull
abbr -a o xdg-open
abbr -a p 'patch -Np1 -i -'
abbr -a rm ' rm'
abbr -a ta 'tmux a || tmux'
abbr -a vb 'VIMRUNTIME=~/b/neovim/runtime NVIM_APPNAME=nvim-test ~/b/neovim/build/bin/nvim'
abbr -a vv 'VIMRUNTIME=~/b/neovim/runtime ~/b/neovim/build/bin/nvim'

# FIXME: standard way to redraw fish prompt
function if_empty
  test -z (string trim (commandline))
  and eval "$argv[1]; return"
  or eval $argv[2]
end

# TODO: generalized -> predicate and a or b
function _s
  set -l line (commandline)
  string match -r '^https?://git(.+)' $line 2>/dev/null 1>&2
  and eval 'commandline -r ""'
  and eval 'git clone $line; return'

  string match -r '^gib (.+)' $line 2>/dev/null 1>&2
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
bind \cs _s
bind \ct repeat_cmd
bind \e\; 'htop'
bind \ei 'tmux a 2>&1 >/dev/null || tmux 2>&1 >/dev/null || tmux det'
bind \el clear
bind \er 'sh2fish.sh && exec fish'
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
