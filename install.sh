#!/bin/bash

sudo apt install -y stow python-pip
stow bash
stow ssh
stow tmux
stow vim
echo "if [ -f ~/.bash_profile_custom ]; then . ~/.bash_profile_custom; fi" >> ~/.bashrc
