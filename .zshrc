. $HOME/.bashrc

autoload -U colors && colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

setopt autocd
setopt interactive_comments
setopt sharehistory

# https://unix.stackexchange.com/questions/568907/why-do-i-lose-my-zsh-history
HISTFILE="$HOME/.zsh_history"
HISTSIZE=500000
SAVEHIST=500000
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.

# bash-like
# setopt NO_AUTOLIST BASH_AUTOLIST NO_MENUCOMPLETE


bindkey -e # must set first
bindkey -s '\eq' '\C-e >/dev/null 2>&1 &'
bindkey -s '\ew' '\C-asudo \C-e'
bindkey -s '\ee' '\C-anvim \C-e'
bindkey -s '\et' '$(compgen -c | fzf)\C-m'
bindkey -s '\eo' 'lfcd\C-m'
bindkey -s '\ej' '\C-e 2>&1 | rg '
bindkey -s '\eg' '\C-e 2>&1 | nvim -'
bindkey -s '\ek' '\C-uclear\C-m'
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

# # https://stackoverflow.com/questions/4405382/how-can-i-read-documentation-about-built-in-zsh-commands
unalias run-help
autoload run-help
alias help='run-help'
