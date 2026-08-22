#!/usr/bin/env bash
# Arch setup: pacman packages (CachyOS repos provide these without needing the AUR)

PACMAN_PACKAGES=(
  discord stow eza starship github-cli ttf-meslo-nerd
  git-delta ghostty zoxide zellij nodejs npm tree-sitter-cli tmux jq
)

print_step "Installing pacman packages"
sudo pacman -S --needed "${PACMAN_PACKAGES[@]}"
print_ok "pacman packages installed"
