#!/bin/bash

# Check for Homebrew, install if we don't have it
if test ! "$(command -v brew)"; then
        echo "Installing homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

[ -f ~/.ssh ] && mkdir ~/.ssh
brew bundle --file=brew/Brewfile
stow zsh
stow git
stow ssh
stow tmux
stow vim
stow p10k
$(brew --prefix)/opt/fzf/install
# Specify the preferences directory
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "~/linux-dotfiles/iterm2"
# Tell iTerm2 to use the custom preferences in the directory
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
