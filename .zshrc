export PROJECTS=~/Code

# functions
fpath=(~/.dotfiles/completions $fpath)

c() {
  cd $PROJECTS/$1;
}

archive() {
  local FILENAME=$1
  local TARGETFILENAME=$2
  local DATE=$(date +"%Y%m%d")
  local ARCHIVE_DIR="$HOME/Dropbox/Archief/"
  if [[ ! -f $1 ]]; then
    echo "File not found."
    return
  fi
  if [[ -z $TARGETFILENAME ]]; then
    TARGETFILENAME=$FILENAME
  fi
  TARGETFILENAME=$ARCHIVE_DIR$DATE" "$TARGETFILENAME
  mv $FILENAME $TARGETFILENAME
  echo $TARGETFILENAME
}

# completion
autoload -U compinit compdef
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
compinit

# vi mode
bindkey -v

# aliases
alias ls="ls -G"

# ruby
eval "$(rbenv init -)"
export PATH="./bin:$PATH"
alias powdir='ln -s $(pwd) ~/.pow'

# vim
alias vi='vim'

# git
alias git=hub
alias gl="git log --branches --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gla="git log --all --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gp='git push origin HEAD'
alias gd='git diff'
alias gf="git fetch"
alias gc='git commit'
alias gca='git commit -a'
alias gco='git checkout'
alias gb='git branch'
alias gm='git merge --no-edit'
alias gs='git status -sb'
alias grm="git status | grep deleted | awk '{print \$3}' | xargs git rm"
alias gr='cd $(git rev-parse --show-toplevel)'

# new tabs go to same directory

function chpwd {
  local SEARCH=' '
  local REPLACE='%20'
  local PWD_URL="file://$HOSTNAME${PWD//$SEARCH/$REPLACE}"
  printf '\e]7;%s\a' "$PWD_URL"
}

chpwd
