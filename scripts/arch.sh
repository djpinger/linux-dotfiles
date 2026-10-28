#!/usr/bin/env bash
# Arch setup: pacman packages (CachyOS repos provide these without needing the AUR),
# plus optional AUR packages through paru or yay when AUR_PACKAGES is non-empty.
# Defines os_select (menus) and os_run (installs); setup.sh calls them.

PACMAN_PACKAGES=(
  discord stow eza starship github-cli ttf-meslo-nerd
  git-delta ghostty zoxide zellij nodejs npm tree-sitter-cli tmux jq
)

# Packages only available from the AUR. Needs paru or yay already installed.
AUR_PACKAGES=()

register_section pacman_packages "pacman packages"
if [ "${#AUR_PACKAGES[@]}" -gt 0 ]; then
  register_section aur_packages "AUR packages (paru/yay)"
fi

os_select() {
  if section_on pacman_packages; then
    select_packages PACMAN_PACKAGES "pacman packages to install"
  fi
  if section_on aur_packages; then
    select_packages AUR_PACKAGES "AUR packages to install"
  fi
}

os_run() {
  if section_on pacman_packages; then
    print_step "Installing pacman packages"
    if [ "${#PACMAN_PACKAGES[@]}" -gt 0 ]; then
      sudo pacman -S --needed "${PACMAN_PACKAGES[@]}"
    fi
    print_ok "pacman packages installed"
  fi

  if section_on aur_packages; then
    print_step "Installing AUR packages"
    local helper=""
    if cmd_exists paru; then
      helper=paru
    elif cmd_exists yay; then
      helper=yay
    fi
    if [ -z "$helper" ]; then
      print_warn "Neither paru nor yay found, skipping AUR packages"
    elif [ "${#AUR_PACKAGES[@]}" -gt 0 ]; then
      "$helper" -S --needed "${AUR_PACKAGES[@]}"
      print_ok "AUR packages installed via $helper"
    fi
  fi
}
