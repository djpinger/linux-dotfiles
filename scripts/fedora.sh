#!/usr/bin/env bash
# Fedora setup: dnf packages, nerd fonts, Linuxbrew + brew packages

export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"

DNF_PACKAGES=(
  stow python3-pip vim curl jq zsh tmux iproute nodejs git
  fd-find ripgrep dnf-plugins-core bat btop fzf gh git-delta
  helm jid k9s starship terraform tig neovim zoxide ghostty
  meslo-nerd-fonts
)

# Packages not in DNF — installed via Linuxbrew
# kind is here instead of DNF because Nobara's kind package conflicts with docker-ce-cli
BREW_PACKAGES=(eza kubectx terragrunt kubecolor zellij tree-sitter-cli kind)

print_step "Adding HashiCorp repo"
if [ ! -f /etc/yum.repos.d/hashicorp.repo ]; then
  sudo curl -fsSL -o /etc/yum.repos.d/hashicorp.repo \
    https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
  print_ok "HashiCorp repo added"
else
  print_ok "HashiCorp repo already present"
fi

print_step "Installing dnf packages"
sudo dnf install -y "${DNF_PACKAGES[@]}"
print_ok "dnf packages installed"

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
