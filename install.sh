#!/bin/bash

sudo apt install -y stow python-pip
stow bash
stow ssh
stow tmux
stow vim
stow powerline
echo "if [ -f ~/.bash_profile_custom ]; then . ~/.bash_profile_custom; fi" >> ~/.bashrc
