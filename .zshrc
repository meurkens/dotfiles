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
alias powdir='ln -s $(pwd) ~/.pow'

# vim
alias vi='vim'

# git
alias git=hub
alias gaa="git add --all"
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

# prompt
setopt prompt_subst
autoload -U colors && colors

parse_git_branch() {
  (git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD) 2> /dev/null
}

git_prompt_string() {
  local GIT_WHERE="$(parse_git_branch)"
  local GIT_STATE=""

  local STATUS="$(git status 2>/dev/null)"
  if [[ ! $STATUS =~ 'nothing to commit' ]]; then
    GIT_STATE="$GIT_STATE%{$fg[green]%}?%{$reset_color%}"
  fi

  local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_AHEAD" -gt 0 ]; then
    GIT_STATE="$GIT_STATE%{$fg[red]%}!%{$reset_color%}"
  fi

  [ -n "$GIT_WHERE" ] && echo " at %{$fg_bold[magenta]%}${GIT_WHERE#(refs/heads/|tags/)}%{$reset_color%}$GIT_STATE"
}

rbenv_prompt_string() {
  local RUBY_VERSION="$(rbenv version | awk '{print $1}')"
  if [[ ! $RUBY_VERSION == 'system' ]]; then
    echo " with %{$fg[cyan]%}$RUBY_VERSION%{$reset_color%}"
  fi
}

PS1=$'\n'"%{$fg_bold[yellow]%}%~%{$reset_color%}"'$(git_prompt_string)$(rbenv_prompt_string)'$'\n'"> "

source ~/.zshenv
