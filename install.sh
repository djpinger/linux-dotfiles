#!/bin/bash

stow bash
stow ssh
stow tmux
stow vim
echo "if [ -f ~/.bash_profile_custom ]; then . ~/.bash_profile_custom; fi" >> ~/.bash_profile
