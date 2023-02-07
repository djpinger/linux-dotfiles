#!/bin/bash

sudo apt update
sudo apt install -y stow python3-pip keychain vim curl jq zsh tmux libpq-dev
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
brew bundle --file=brew/Brewfile
#pip3 install powerline-shell
if [ ! -d ~/.config ]
    then
    mkdir .config
fi
stow asdf
stow bash
stow ssh
stow tmux
stow vim
stow powerline
stow git
stow zsh
stow p10k
stow terminator
#echo "if [ -f ~/.bash_custom ]; then . ~/.bash_custom; fi" >> ~/.bashrc
dconf load /com/gexperts/Tilix/ < tilix/tilix.dconf
