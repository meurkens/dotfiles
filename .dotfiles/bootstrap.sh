#!/bin/bash

# Hide untracked files from `dotfiles status`
git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME config --local status.showUntrackedFiles no
