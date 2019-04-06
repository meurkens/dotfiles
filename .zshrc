export PATH="/home/meurkens/.linuxbrew/bin:$PATH"
export MANPATH="/home/meurkens/.linuxbrew/share/man:$MANPATH"
export INFOPATH="/home/meurkens/.linuxbrew/share/info:$INFOPATH"

eval "$(rbenv init -)"
export PATH="./bin:./node_modules/.bin:/usr/local/opt/postgresql@9.6/bin:$PATH"
export EDITOR="vim"

# alias vim="mvim -v"
alias vi=vim
alias ls="ls -G"
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'

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
autoload -U compinit compdef
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
compinit

# Set working dir in prompt
setopt promptsubst
PROMPT='
${PWD/#$HOME/~}
> '

export FZF_DEFAULT_COMMAND='rg --files --hidden --follow -g "!{.git}/*" 2> /dev/null'

