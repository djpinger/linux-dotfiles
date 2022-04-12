#!/bin/bash

# Check for Homebrew, install if we don't have it
if test ! "$(command -v brew)"; then
        echo "Installing homebrew..."
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

[ -f ~/.ssh ] && mkdir ~/.ssh
brew bundle --file=brew/Brewfile
stow zsh
stow git
stow ssh
stow tmux
stow vim
stow p10k
./iterm2_setup.sh
$(brew --prefix)/opt/fzf/install
