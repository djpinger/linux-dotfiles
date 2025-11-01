#!/bin/bash

paru -Syu --noconfirm 1password discord stow exa asdf-vm starship github-cli ttf-meslo-nerd git-delta ghostty
if [ ! -d ~/.config ]
then
	mkdir ~/.config
fi
stow asdf
stow zsh
stow git
stow ssh
stow tmux
stow vim
stow neovim
stow starship
stow cli
stow ghostty
