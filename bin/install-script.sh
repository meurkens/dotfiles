#!/usr/bin/env bash

# Ask for the administrator password upfront
# and keep-alive: update existing `sudo` time stamp until script has finished
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

xcode-select --install

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew doctor
brew update

brew install caskroom/cask/brew-cask
brew cask install dropbox

# todo ask dropbox login

brew install ag
brew install git
brew install heroku-toolkit
brew install imagemagick
brew install hub
brew install macvim --override-system-vim
brew install mongo

brew install mysql
ln -sfv /usr/local/opt/mysql/*.plist ~/Library/LaunchAgents
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist

brew install phantomjs

brew install postgres
ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist

brew install pow
mkdir -p ~/Library/Application\ Support/Pow/Hosts
ln -s ~/Library/Application\ Support/Pow/Hosts ~/.pow
sudo pow --install-system
pow --install-local
sudo launchctl load -w /Library/LaunchDaemons/cx.pow.firewall.plist
launchctl load -w ~/Library/LaunchAgents/cx.pow.powd.plist

brew install rbenv
brew install reattach-to-user-namespace
brew install ruby-build
brew install tmux
brew install unrar
brew install zsh

brew cleanup

brew cask install 1password
brew caks install appcleaner
brew cask install arq
brew cask install beamer
brew cask install choosy
brew cask install firefox
brew cask install google-chrome
brew cask install hipchat
brew cask install mailbox
brew cask install spotify
brew cask install subtitles
brew cask install transmission
brew cask install virtualbox
brew cask install vlc

brew cask cleanup

git config --global user.name "Stijn Meurkens"
git config --global user.email meurkens@gmail.com

# dropbox should have loaded the directory structure by now

# todo: install dotfiles
# todo: install secure dotfiles from Dropbox (.gitconfig)
ln -s ~/Dropbox/Backups/ssh ~/.ssh

# todo: terminal theme

# use zsh as default
if ! grep -q "/usr/local/bin/zsh" /etc/shells; then
  echo "/usr/local/bin/zsh" | sudo tee -a /etc/shells
fi
chsh -s /usr/local/bin/zsh

rm -rf ~/Music/iTunes
ln -s ~/Dropbox/Appdata/iTunes ~/Music/

mkdir ~/Code

# superfast keyboard repeat
defaults write NSGlobalDomain KeyRepeat -int 0

# fix find-on-page in safari
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool FALSE

# todo: list app store downloads
# harvest, doublepane, telephone

# todo: sketch, omnifocus, pixelmator

# todo: list settings that script can't do for me
# 1password: install browser extensions
# doublepane: keyboard settings
# safari: uncheck 'open safe files after downloading'
# safari: advanced; show full address, show develop menu
# osx: tap to click, three finger drag
# osx: delete directories from finder pane
# osx: display settings; do not auto adjust brightness
# osx: keyboard settings; tab to all controls, caps lock off
# osx: keyboard settings; quick repeat
# osx: sharing settings; computer name
# terminal: pro-theme, source code pro font, no bells in profile->advanced
