#!/bin/bash

sudo apt install -y stow python-pip keychain vim gnome-tweaks tilix curl
pip install powerline-shell
stow bash
stow ssh
stow tmux
stow vim
stow powerline
echo "if [ -f ~/.bash_profile_custom ]; then . ~/.bash_profile_custom; fi" >> ~/.bashrc
mkdir ~/.fonts
curl -s -k -o ~/.fonts/Hack-Regular.ttf https://github.com/powerline/fonts/raw/master/Hack/Hack-Regular.ttf
dconf load /com/gexperts/Tilix/ < tilix/tilix.dconf
