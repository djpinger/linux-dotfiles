#!/usr/bin/env bash
# Ubuntu Server setup: apt, Docker, Linuxbrew, brew packages

export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"

APT_PACKAGES=(
  stow python3-pip vim curl jq zsh tmux
  libpq-dev apt-transport-https net-tools
)

BREW_PACKAGES=(
  bat btop eza fzf node gh git-delta helm jid k9s kind
  kubectx starship terraform terragrunt tig kubecolor neovim zoxide zellij
  tree-sitter-cli
)

print_step "Installing apt packages"
sudo apt-get update -qq
sudo apt-get install -y "${APT_PACKAGES[@]}"
print_ok "apt packages installed"

print_step "Installing Docker"
if cmd_exists docker; then
  print_ok "Docker already installed"
else
  curl -fsSL https://get.docker.com | sudo sh
  print_ok "Docker installed"
fi

print_step "Adding user to docker group"
sudo usermod -aG docker "$USER"
print_ok "User added to docker group (re-login to take effect)"

print_step "Installing Linuxbrew"
if [ -f "$HOMEBREW_PREFIX/bin/brew" ]; then
  print_ok "Linuxbrew already installed"
else
  sudo mkdir -p "$HOMEBREW_PREFIX"
  sudo chown -R "$USER:$USER" "$HOMEBREW_PREFIX"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  print_ok "Linuxbrew installed"
fi

export PATH="$HOMEBREW_PREFIX/bin:$PATH"

print_step "Installing brew packages"
brew install "${BREW_PACKAGES[@]}"
print_ok "brew packages installed"
