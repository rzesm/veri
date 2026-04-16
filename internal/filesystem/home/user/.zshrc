PROMPT='%B%~ %n ❯%b '
PROMPT_EOL_MARK=''

# Set window title
precmd() {
    print -Pn "\e]2;%~\a"
}

HISTFILE=~/.zsh_history
HISTSIZE=2000
SAVEHIST=2000

autoload -Uz compinit && compinit
autoload -Uz colors && colors

# Autocomplete
source /usr/share/zsh/plugins/fzf-tab-git/fzf-tab.plugin.zsh

# Syntax highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
ZSH_HIGHLIGHT_STYLES[command]='fg=white,bold'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=white,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=white,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=white,bold'

# Keys

# Restore delete key functionality
bindkey '^[[3~' delete-char

# Fix word boundaries
WORDCHARS='_'

# Ctrl movement/deletion
bindkey '^[[3;5~' kill-word
bindkey '\C-h' backward-kill-word
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# Aliases

alias ls="eza --group-directories-first -l"
alias yay="yay --color=auto"
alias diff="diff --color=auto"
