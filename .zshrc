export PATH="$HOME/.dotfiles/bin:$HOME/.local/bin:./bin:./node_modules/.bin:/opt/homebrew/bin:$PATH"
export PATH="$HOME/.ghcup/bin:$HOME/.cabal/bin:$PATH"

export EDITOR="vim"
export LANG='en_US.UTF-8'
export TERM=screen-256color

alias vi=vim
alias ls="ls -G"
alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'
alias btreset="blueutil -p 0 && sleep 1 && blueutil -p 1"
alias vim="mvim -v"

alias gb="git branch"
alias gc="git commit"
alias gca="git commit -a"
alias gco="git checkout"
alias gd="git diff"
alias gf="git fetch"
alias gl="git log --branches --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gla="gl --all"
alias gp="git push origin HEAD"
alias gr='git rev-parse --show-toplevel | xargs cd'
alias gs="git status -sb"

# Vi mode
bindkey -v
bindkey '^R' history-incremental-search-backward

# Autocompletion
autoload -U compinit compdef bashcompinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
bashcompinit
compinit

# Set working dir in prompt
setopt promptsubst
PROMPT='
${PWD/#$HOME/~}
> '

export FZF_DEFAULT_COMMAND='rg --files --hidden --follow -g "!{.git}/*" 2> /dev/null'

. /opt/homebrew/opt/asdf/libexec/asdf.sh
. /opt/homebrew/opt/asdf/etc/bash_completion.d/asdf.bash
