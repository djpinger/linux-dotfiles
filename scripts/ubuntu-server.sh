#!/usr/bin/env bash
# Ubuntu Server setup: apt, Docker, Linuxbrew, brew packages
# Defines os_select (menus) and os_run (installs); setup.sh calls them.

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

register_section apt_packages "apt packages"
register_section docker "Docker + docker group"
register_section brew_packages "Linuxbrew + brew packages"

os_select() {
  if section_on apt_packages; then
    select_packages APT_PACKAGES "apt packages to install"
  fi
  if section_on brew_packages; then
    select_packages BREW_PACKAGES "brew packages to install"
  fi
}

os_run() {
  export PATH="$HOMEBREW_PREFIX/bin:$PATH"

  if section_on apt_packages; then
    print_step "Installing apt packages"
    sudo apt-get update -qq
    if [ "${#APT_PACKAGES[@]}" -gt 0 ]; then
      sudo apt-get install -y "${APT_PACKAGES[@]}"
    fi
    print_ok "apt packages installed"
  fi

  if section_on docker; then
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
  fi

  if section_on brew_packages; then
    ensure_homebrew

    print_step "Installing brew packages"
    if [ "${#BREW_PACKAGES[@]}" -gt 0 ]; then
      brew install "${BREW_PACKAGES[@]}"
    fi
    print_ok "brew packages installed"
  fi
}
