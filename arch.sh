#!/bin/bash

yay -S --noconfirm 1password slack-desktop discord vim stow aws-cli aws-vault k9s kubectx eksctl kubectl keychain exa helm asdf-vm starship github-cli alacritty zellij ttf-meslo-nerd git-delta
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
