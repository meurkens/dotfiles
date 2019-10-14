#!/bin/bash

echo "Configuring dotfiles repo..."
alias dotfiles='git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'
dotfiles config --local status.showUntrackedFiles no
dotfiles remote remove origin
dotfiles remote add origin git@github.com:meurkens/dotfiles

echo "Installing xcode..."
read -p "Please install and run XCode first, Press [Enter] to continue"

echo "Installing homebrew..."
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew bundle
brew cleanup

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

echo "Configuring macOS settings..."
sh ~/.macos

echo "Configuring vim..."
vim +PlugInstall +qa!

read -p "Press [Enter] after Dropbox file structure has loaded, otherwise quit using Ctrl-C..."

echo "Linking iTunes music..."
rm -rf ~/Music/iTunes
ln -s ~/Dropbox/Appdata/iTunes ~/Music/

echo "Linking GPG dir..."
ln -s ~/Dropbox/Appdata/gnupg.symlink ~/.gnupg

echo "Linking further install instructions on Desktop..."
ln -s "$HOME/.dotfiles/install.txt" ~/Desktop

echo "Linking inbox on Desktop..."
ln -s ~/Dropbox/Inbox ~/Desktop/

echo "Installation complete!"
echo "Please reboot computer before continuing..."
