##!/bin/bash
#This is an interesting alternative that I'd like to try.

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
git clone --bare git@github.com:djpinger/linux-dotfiles.git $HOME/.cfg
config checkout
