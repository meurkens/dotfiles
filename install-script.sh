#!/usr/bin/env bash

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


# homebrew
# ========

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


# todo: install .ssh
# ==================

# use zsh
# =======
if ! grep -q "/usr/local/bin/zsh" /etc/shells; then
  echo "/usr/local/bin/zsh" | sudo tee -a /etc/shells
fi
chsh -s /usr/local/bin/zsh

# osx settings
# ===========

sh ~/.dotfiles/.osx

# todo: terminal theme
# ====================

# misc
# ====

# Link Dropbox music
rm -rf ~/Music/iTunes
ln -s ~/Dropbox/Appdata/iTunes ~/Music/

# Create a place to code
mkdir ~/Code


# todo: list app store downloads
# telephone, pixelmator

# todo: pixelmator

# todo: list settings that script can't do for me
# 1password: install browser extensions
# spectacle: keyboard settings
# safari: advanced; show develop menu
# osx: delete directories from finder pane
# osx: display settings; do not auto adjust brightness
# osx: keyboard settings; tab to all controls, caps lock off
# osx: keyboard settings; quick repeat
# osx: sharing settings; computer name
# terminal: pro-theme, source code pro font, no bells in profile->advanced
