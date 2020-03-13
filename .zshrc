eval "$(rbenv init -)"
export PATH="./bin:./node_modules/.bin:$PATH"
export EDITOR="vim"

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
alias gla="git log --all --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gp="git push origin HEAD"
alias gr='cd $(git rev-parse --show-toplevel)'
alias gs="git status"


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

. /usr/local/opt/asdf/asdf.sh
. /usr/local/opt/asdf/etc/bash_completion.d/asdf.bash

export ANDROID_SDK=/Users/meurkens/Library/Android/sdk
export PATH=/Users/meurkens/Library/Android/sdk/platform-tools:$PATH
