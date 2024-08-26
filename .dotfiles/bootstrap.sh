#!/bin/bash

set -euo pipefail

echo "Configuring dotfiles repo..."
alias dotfiles='git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'
dotfiles config --local status.showUntrackedFiles no
dotfiles remote remove origin
dotfiles remote add origin git@github.com:meurkens/dotfiles

echo "Installing homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
brew bundle
brew cleanup

echo "Configuring git..."
git config --global user.name "Stijn Meurkens"
git config --global user.email meurkens@gmail.com

echo "Configuring zsh as default shell..."
if ! grep -q "/opt/homebrew/bin/zsh" /etc/shells; then
  echo "/opt/homebrew/bin/zsh" | sudo tee -a /etc/shells
fi
chsh -s /opt/homebrew/bin/zsh

echo "Creating Code directory..."
mkdir ~/Code

echo "Configuring macOS settings..."
sh ~/.macos

echo "Install programming languages..."
cd
cat .tool-versions | cut -d' ' -f1 | grep "^[^\#]" | xargs -i asdf plugin add  {}

echo "Configuring vim..."
vim +PlugInstall +qa!

read -p "Press [Enter] after Dropbox file structure has loaded, otherwise quit using Ctrl-C..."

echo "Linking iTunes music..."
rm -rf ~/Music/iTunes
ln -s ~/Dropbox/Appdata/iTunes ~/Music/

echo "Linking private dotfiles..."
find ~/Dropbox/Appdata/dotfiles -name "*.symlink" -exec sh -c 'ln -s {} ./."$(basename {} .symlink)"' \;

echo "Linking further install instructions on Desktop..."
ln -s "$HOME/.dotfiles/install.txt" ~/Desktop

echo "Linking inbox on Desktop..."
ln -s ~/Dropbox/Inbox ~/Desktop/

echo "Installation complete!"
echo "Please reboot computer before continuing..."
