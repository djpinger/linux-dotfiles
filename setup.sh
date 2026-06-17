#!/usr/bin/env bash
# Usage: ./setup.sh [mac|ubuntu|arch|fedora]

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES_DIR

RED='\033[0;31m'
GREEN='\033[0;32m'
RESET='\033[0m'

if [ -z "$1" ] || [[ ! "$1" =~ ^(mac|ubuntu|ubuntu-server|arch|fedora)$ ]]; then
  echo -e "${RED}Usage: ./setup.sh [mac|ubuntu|ubuntu-server|arch|fedora]${RESET}"
  exit 1
fi

TARGET="$1"

source "$DOTFILES_DIR/scripts/lib.sh"

# Collect all interactive inputs upfront
echo -e "${GREEN}linux-dotfiles setup — $TARGET${RESET}"
echo

# Ghostty: only prompt if the machine-specific config doesn't exist yet (not needed on servers)
if [[ "$TARGET" != "ubuntu-server" ]] && [ ! -f "$HOME/.config/ghostty/local.config" ]; then
  read -rp "Ghostty font size [15]: " _input
  export GHOSTTY_FONT_SIZE="${_input:-15}"
fi

# WSL: prompt for WezTerm font size before anything else runs
if [ "$TARGET" = "ubuntu" ] && grep -qi microsoft /proc/version 2>/dev/null; then
  WIN_USER=$(powershell.exe -Command '$env:USERNAME' 2>/dev/null | tr -d '\r')
  WIN_LOCAL="/mnt/c/Users/$WIN_USER/.config/wezterm/local.lua"
  if [ ! -f "$WIN_LOCAL" ]; then
    read -rp "WezTerm font size [11]: " _input
    export WEZTERM_FONT_SIZE="${_input:-11}"
  fi
fi

echo

# OS-specific setup
source "$DOTFILES_DIR/scripts/$TARGET.sh"

# Common setup (stow, nvim, tmux, ghostty, zellij, npm)
source "$DOTFILES_DIR/scripts/common.sh"

echo
echo -e "${GREEN}Setup complete.${RESET}"
echo
echo "Manual steps remaining:"
echo "  - Configure git user name and email"
echo "  - Set up SSH keys"
echo "  - Set up cloud provider credentials (AWS, GCP)"
if [ "$TARGET" = "mac" ]; then
  echo "  - Configure 1Password SSH agent"
fi
if [[ "$TARGET" =~ ^(ubuntu|ubuntu-server|fedora)$ ]]; then
  echo "  - Log out and back in for docker group membership to take effect"
fi
