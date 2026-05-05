#!/usr/bin/env bash
# macOS setup: Homebrew, brew packages, casks, fzf shell integration, iTerm2

export HOMEBREW_PREFIX="/opt/homebrew"

BREW_PACKAGES=(
  bat btop eza fzf node gh git-delta helm jid k9s kind
  kubectx starship terraform terragrunt tig kubecolor neovim zoxide zellij
  git jq stow tmux tree-sitter-cli
)

BREW_CASKS=(
  google-cloud-sdk font-hack-nerd-font font-meslo-lg-nerd-font
  rectangle stats raycast cmux
)

print_step "Installing Homebrew"
if [ -f "$HOMEBREW_PREFIX/bin/brew" ]; then
  print_ok "Homebrew already installed"
else
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  print_ok "Homebrew installed"
fi

export PATH="$HOMEBREW_PREFIX/bin:$PATH"

print_step "Updating Homebrew"
brew update
print_ok "Homebrew updated"

print_step "Installing brew packages"
brew install "${BREW_PACKAGES[@]}"
print_ok "brew packages installed"

print_step "Tapping manaflow-ai/cmux"
brew tap manaflow-ai/cmux
print_ok "Tap added"

print_step "Installing brew casks"
brew install --cask "${BREW_CASKS[@]}"
print_ok "Casks installed"

print_step "Installing gcloud auth plugin"
if cmd_exists gcloud; then
  gcloud components install gke-gcloud-auth-plugin --quiet || true
  print_ok "gcloud auth plugin installed"
else
  print_warn "gcloud not found, skipping auth plugin"
fi

print_step "Configuring fzf shell integration"
if [ -f "$HOME/.fzf.zsh" ]; then
  print_ok "fzf already configured"
else
  "$HOMEBREW_PREFIX/opt/fzf/install" --all
  print_ok "fzf shell integration installed"
fi

print_step "Configuring iTerm2"
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "~/linux-dotfiles/iterm2"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
print_ok "iTerm2 preferences configured"
