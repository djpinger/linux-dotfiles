#!/usr/bin/env bash
# Fedora setup: dnf packages, nerd fonts, Linuxbrew + brew packages
# Defines os_select (menus) and os_run (installs); setup.sh calls them.

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

register_section dnf_packages "dnf packages"
register_section brew_packages "Linuxbrew + brew packages"

os_select() {
  if section_on dnf_packages; then
    select_packages DNF_PACKAGES "dnf packages to install"
  fi
  if section_on brew_packages; then
    select_packages BREW_PACKAGES "brew packages to install"
  fi
}

os_run() {
  export PATH="$HOMEBREW_PREFIX/bin:$PATH"

  if section_on dnf_packages; then
    # The terraform package comes from the HashiCorp repo, so only add it if terraform is selected
    if [[ " ${DNF_PACKAGES[*]} " == *" terraform "* ]]; then
      print_step "Adding HashiCorp repo"
      if [ ! -f /etc/yum.repos.d/hashicorp.repo ]; then
        sudo curl -fsSL -o /etc/yum.repos.d/hashicorp.repo \
          https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
        print_ok "HashiCorp repo added"
      else
        print_ok "HashiCorp repo already present"
      fi
    fi

    print_step "Installing dnf packages"
    if [ "${#DNF_PACKAGES[@]}" -gt 0 ]; then
      sudo dnf install -y "${DNF_PACKAGES[@]}"
    fi
    print_ok "dnf packages installed"
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
