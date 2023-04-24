. $HOME/.bashrc

autoload -U colors && colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

setopt autocd
setopt interactive_comments
# bash-like
# setopt NO_AUTOLIST BASH_AUTOLIST NO_MENUCOMPLETE


bindkey -e # must set first
bindkey -s '\eq' '\C-e >/dev/null 2>&1 &'
bindkey -s '\ew' '\C-asudo \C-e'
bindkey -s '\ee' '\C-anvim \C-e'
bindkey -s '\et' '$(compgen -c | fzf)\C-m'
bindkey -s '\eo' 'lfcd\C-m'
bindkey -s '\eg' '\C-e2>&1 | rg '
bindkey -s '\ej' '\C-e2>&1 | nvim -'
bindkey -s '\ek' '\C-e\C-uclear\C-m'
bindkey -s '\el' '\C-e | bat'

# zsh complete
autoload -U compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' insert-tab false
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# include hidden files.

# fancy completion 
# https://www.reddit.com/r/zsh/comments/msps0/color_partial_tab_completions_in_zsh/
zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)(?)*==02=01}:${(s.:.)LS_COLORS}")'

# load syntax highlighting; should be last
# . /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh 2>/dev/null
. /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
. /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
