#!/usr/bin/env bash

# Ask for the administrator password upfront
# and keep-alive: update existing `sudo` time stamp until script has finished
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo "Installing xcode..."

xcode-select --install

echo "Installing homebrew..."

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew doctor
brew update
brew bundle
brew cleanup -f
brew cask cleanup -f

echo "Configuring git..."

git config --global user.name "Stijn Meurkens"
git config --global user.email meurkens@gmail.com

echo "Configuring zsh as default shell..."

if ! grep -q "/usr/local/bin/zsh" /etc/shells; then
  echo "/usr/local/bin/zsh" | sudo tee -a /etc/shells
fi
chsh -s /usr/local/bin/zsh

echo "Creating Code directory..."

mkdir ~/Code

echo "Configuring OS X settings..."

sh ./.osx

echo "Installing dotfiles..."

for src in $(find -H "./" -maxdepth 2 -name '*.symlink' -not -path '*.git*')
do
  dst="~/.$(basename "${src%.*}")"
  rm -rf "$dst"
  if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]
  then
    ln -s "$src" "$dst"
  fi
done

# TODO
# - make instructions to load from github

cat <<--EOF
# User should do:
# - Set computer name
# - Install app store programs
#   - Pixelmator
#   - Telephone
#   - XCode
#   - Letterspace
#   - Keynote
# - Install source code pro font
#   > https://github.com/adobe-fonts/source-code-pro/releases
# - Install terminal theme
# - Install safari extensions
#   - 1Password
#   - Pocket
#   - uBlock
# - Login to dropbox & sync iTunes music
#   > rm -rf ~/Music/iTunes
#   > ln -s ~/Dropbox/Appdata/iTunes ~/Music/
# - Customize finder pane
# - Display setting: do not auto adjust brightness
# - Configure apps
#   - Spectacles
#   - Arq
# - Contacts sync Google
EOF

