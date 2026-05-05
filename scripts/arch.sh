#!/usr/bin/env bash
# Arch setup: paru packages (paru must be installed before running)

PARU_PACKAGES=(
  1password discord stow eza starship github-cli ttf-meslo-nerd
  git-delta ghostty zoxide zellij nodejs npm tree-sitter-cli
)

print_step "Installing paru packages"
if ! cmd_exists paru; then
  print_err "paru is not installed. Install it first: https://github.com/Morganamilo/paru"
  exit 1
fi
paru -S --needed "${PARU_PACKAGES[@]}"
print_ok "paru packages installed"
