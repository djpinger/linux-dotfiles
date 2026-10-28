#!/usr/bin/env bash
# Usage: ./setup.sh [-d] [mac|ubuntu|ubuntu-server|arch|fedora]
#   (no flag)        interactive: pick which sections run and which packages install (uses gum)
#   -d, --defaults   skip the menus; run every section with the default package lists

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES_DIR

source "$DOTFILES_DIR/scripts/lib.sh"

usage() {
  echo -e "${RED}Usage: ./setup.sh [-d] [mac|ubuntu|ubuntu-server|arch|fedora]${RESET}"
  echo "  -d, --defaults   skip the interactive menus and use the default selections"
}

TARGET=""
for arg in "$@"; do
  case "$arg" in
    -d|--defaults) INTERACTIVE=false ;;
    -h|--help) usage; exit 0 ;;
    mac|ubuntu|ubuntu-server|arch|fedora) TARGET="$arg" ;;
    *) usage; exit 1 ;;
  esac
done

if [ -z "$TARGET" ]; then
  usage
  exit 1
fi

# Menus need a terminal; fall back to defaults when piped or run from CI
if [ "$INTERACTIVE" = true ] && { [ ! -t 0 ] || [ ! -t 1 ]; }; then
  print_warn "No terminal detected, using defaults"
  INTERACTIVE=false
fi

echo -e "${GREEN}linux-dotfiles setup — $TARGET${RESET}"
echo

# Declare sections and package lists (no side effects until the *_run functions)
source "$DOTFILES_DIR/scripts/$TARGET.sh"
source "$DOTFILES_DIR/scripts/common.sh"
if [ "$TARGET" = "mac" ]; then
  source "$DOTFILES_DIR/scripts/mac-defaults.sh"
fi

# Collect all interactive input upfront
if [ "$INTERACTIVE" = true ]; then
  ensure_gum
  choose_sections
  os_select
  common_select

  echo
  gum confirm "Run setup with these selections?" || { echo "Aborted."; exit 0; }
fi

# Ghostty: only prompt if the machine-specific config doesn't exist yet (not needed on servers)
if section_on ghostty_config && [[ "$TARGET" != "ubuntu-server" ]] && [ ! -f "$HOME/.config/ghostty/local.config" ]; then
  if [ "$INTERACTIVE" = true ]; then
    GHOSTTY_FONT_SIZE=$(gum input --header "Ghostty font size" --value 15) || exit 1
  else
    GHOSTTY_FONT_SIZE=15
  fi
  export GHOSTTY_FONT_SIZE="${GHOSTTY_FONT_SIZE:-15}"
fi

echo

# OS-specific setup
os_run

# Common setup (stow, nvim, tmux, ghostty, zellij, npm)
common_run

# macOS settings (Dock, trackpad, menu bar)
if [ "$TARGET" = "mac" ]; then
  mac_defaults_run
fi

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
