emulate sh -c '. ~/.shellrc'

autoload -U colors && colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

setopt autocd
setopt interactive_comments
setopt sharehistory

# history, https://unix.stackexchange.com/questions/568907/why-do-i-lose-my-zsh-history
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
bindkey -s '\eq' '\C-a\C-e >/dev/null 2>&1 &'
bindkey -s '\ew' '\C-asudo \C-a\C-e'
# bindkey -s '\eo' '\C-ulfcd\C-m'
bindkey -s '\ej' '\C-a\C-e 2>&1 | rg '
bindkey -s '\eg' '\C-a\C-e 2>&1 | nvim -'
bindkey -s '\ek' '\C-uclear\C-m'
bindkey -s '\el' '\C-a\C-e | bat'
bindkey -s '\es' '\C-uresource\C-m'

# complete, https://thevaluable.dev/zsh-completion-guide-examples/
autoload -U compinit
zstyle ':completion:*' insert-tab false
zstyle ':completion:*' rehash true # auto rehash
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# include hidden files.

# zstyle ':completion:*' menu select
# bindkey -M menuselect '^P' vi-up-line-or-history
# bindkey -M menuselect '^N' vi-down-line-or-history

# partial color, https://www.reddit.com/r/zsh/comments/msps0/color_partial_tab_completions_in_zsh/
# zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)(?)*==02=01}:${(s.:.)LS_COLORS}")'

# load syntax highlighting; should be last
# . /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh 2>/dev/null
# https://github.com/Aloxaf/fzf-tab/wiki/Configuration
. /usr/share/zsh/plugins/fzf-tab-git/fzf-tab.plugin.zsh
# zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[w]'
zstyle ':fzf-tab:*' switch-group 'ctrl-p' 'ctrl-n'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:*' fzf-bindings 'space:accept' ';:abort' # 'ctrl-a:toggle-all'
bindkey '\ee' toggle-fzf-tab

bindkey "^N" history-search-forward
bindkey "^P" history-search-backward

# https://stackoverflow.com/questions/4405382/how-can-i-read-documentation-about-built-in-zsh-commands
unalias run-help
autoload run-help
alias help='run-help'

# edit in editor
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# fish-like smart c-w, https://unix.stackexchange.com/questions/258656/how-can-i-have-two-keystrokes-to-delete-to-either-a-slash-or-a-word-in-zsh
backward-kill-path-component () {
    local WORDCHARS=${WORDCHARS/\/}
    zle backward-kill-word
    zle -f kill
}
zle -N backward-kill-path-component
bindkey '^W' backward-kill-path-component

# https://dev.to/frost/fish-style-abbreviations-in-zsh-40aa
# declare a list of expandable aliases to fill up later
typeset -a ealiases
ealiases=()

# write a function for adding an alias to the list mentioned above
function abbrev-alias() {
    alias $1
    export $1
    ealiases+=(${1%%\=*})
}

# expand any aliases in the current line buffer
function expand-ealias() {
    if [[ $LBUFFER =~ "\<(${(j:|:)ealiases})\$" ]] && [[ "$LBUFFER" != "\\"* ]]; then
        zle _expand_alias
        zle expand-word
    fi
    zle magic-space
}
zle -N expand-ealias

# Bind the space key to the expand-alias function above, so that space will expand any expandable aliases
bindkey ' '        expand-ealias
bindkey -M isearch " "      magic-space     # normal space during searches
# disable is search mode?

# A function for expanding any aliases before accepting the line as is and executing the entered command
expand-alias-and-accept-line() {
    expand-ealias
    zle .backward-delete-char
    zle .accept-line
}
zle -N accept-line expand-alias-and-accept-line

abbrev-alias px='http_proxy=http://127.0.0.1:7890 https_proxy=http://127.0.0.1:7890 all_proxy=http://127.0.0.1:7890'
abbrev-alias spx='--preserve-env=http_proxy,https_proxy,all_proxy'

. /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
. /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"
