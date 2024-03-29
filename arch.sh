#!/bin/bash

yay -S --noconfirm zsh-theme-powerlevel10k-git 1password slack-desktop discord vim stow aws-cli aws-vault k9s kubectx eksctl kubectl keychain exa ttf-meslo-nerd-font-powerlevel10k helm exa asdf-vm noto-fonts-emoji noto-color-emoji-fontconfig
if [ ! -d ~/.config ]
then
	mkdir ~/.config
fi
stow asdf
stow ssh
stow tmux
stow vim
stow p10k
stow git
stow zsh
