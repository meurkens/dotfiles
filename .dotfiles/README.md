# My .files

Inspired by these guides:
- https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/
- https://news.ycombinator.com/item?id=11070797

Bootstrap along these lines:
```
git clone --bare https://github.com/meurkens/dotfiles $HOME/.dotfiles.git
git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME checkout
(cd .dotfiles; sh ./bootstrap.sh)
```
