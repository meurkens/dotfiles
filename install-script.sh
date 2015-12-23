#!/usr/bin/env bash

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


# homebrew
# ========

echo "Installing homebrew..."

xcode-select --install
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew bundle --file=~/.dotfiles/Brewfile
brew cleanup


# install dotfiles
# =====================

echo "Installing dotfiles..."

DOTFILES_DIR=$(pwd -P)

for src in $(find -H "$DOTFILES_DIR" -maxdepth 2 -name '*.symlink' -not -path '*.git*')
do
  dst="$HOME/.$(basename "${src%.*}")"
  ln -sFf "$src" "$dst"
done


# use zsh
# =======

echo "Setting ZSH as default shell..."

if ! grep -q "/usr/local/bin/zsh" /etc/shells; then
  echo "/usr/local/bin/zsh" | tee -a /etc/shells
fi

# TODO: asks for password, again. :-(
sudo chsh -s /usr/local/bin/zsh


# osx settings
# ===========

echo "Configuring OS X..."

sh ~/.dotfiles/.osx


# homedir
# =======

# TODO: make sure Dropbox is syncing

echo "Setting up home dir..."

# Link Dropbox music
rm -rf ~/Music/iTunes
ln -s ~/Dropbox/Appdata/iTunes ~/Music/

# Create a place to code
mkdir ~/Code


# list stuff that script can't do for me:
# - install ssh
# - app store downloads: telephone, pixelmator, xcode
# - 1password: install browser extensions
# - spectacle: keyboard settings
