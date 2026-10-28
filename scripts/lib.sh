#!/usr/bin/env bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

print_step() { echo -e "\n${BLUE}==> $*${RESET}"; }
print_ok()   { echo -e "${GREEN}  ✓ $*${RESET}"; }
print_warn() { echo -e "${YELLOW}  ! $*${RESET}"; }
print_err()  { echo -e "${RED}  ✗ $*${RESET}"; }

cmd_exists() { command -v "$1" &>/dev/null; }

# ---------------------------------------------------------------------------
# Interactive selection (gum)
#
# Each script declares its sections with register_section and its package
# arrays at the top level (no side effects). setup.sh then optionally shows
# menus (INTERACTIVE=true) that prune ENABLED_SECTIONS and the package arrays
# before any <script>_run function executes. With -d everything stays enabled.
# ---------------------------------------------------------------------------

INTERACTIVE=true
GUM_KEYS_HELP="x: toggle  ctrl+a: select all  enter: confirm  ctrl+c: cancel"
SECTION_KEYS=()
SECTION_LABELS=()
ENABLED_SECTIONS=" "

# register_section <key> <label>   (labels must not contain commas)
register_section() {
  SECTION_KEYS+=("$1")
  SECTION_LABELS+=("$2")
  ENABLED_SECTIONS+="$1 "
}

section_on() { [[ "$ENABLED_SECTIONS" == *" $1 "* ]]; }

ensure_homebrew() {
  print_step "Installing Homebrew"
  if [ -f "$HOMEBREW_PREFIX/bin/brew" ]; then
    print_ok "Homebrew already installed"
  else
    if [[ "$(uname)" != "Darwin" ]]; then
      sudo mkdir -p "$HOMEBREW_PREFIX"
      sudo chown -R "$USER:$USER" "$HOMEBREW_PREFIX"
    fi
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    print_ok "Homebrew installed"
  fi
  export PATH="$HOMEBREW_PREFIX/bin:$PATH"
}

# gum must exist before the OS script runs, so this bootstraps its prerequisites.
ensure_gum() {
  if cmd_exists gum; then
    return 0
  fi
  print_step "Installing gum (interactive menus)"
  case "$TARGET" in
    arch)
      sudo pacman -S --needed --noconfirm gum
      ;;
    ubuntu|ubuntu-server)
      sudo apt-get update -qq
      sudo apt-get install -y curl git
      ensure_homebrew
      brew install gum
      ;;
    fedora)
      sudo dnf install -y curl git
      ensure_homebrew
      brew install gum
      ;;
    *)
      ensure_homebrew
      brew install gum
      ;;
  esac
  print_ok "gum installed"
}

# Checklist of registered sections; unticked ones are removed from ENABLED_SECTIONS.
choose_sections() {
  [ "$INTERACTIVE" = true ] || return 0
  [ "${#SECTION_KEYS[@]}" -gt 0 ] || return 0
  local selected out i
  selected=$(IFS=,; echo "${SECTION_LABELS[*]}")
  out=$(gum choose --no-limit --height 25 \
    --header "Sections to run
$GUM_KEYS_HELP
Sections with package lists (brew, apt, pacman, dnf, stow...) open a second menu to pick packages." \
    --selected "$selected" "${SECTION_LABELS[@]}") || { print_err "Cancelled"; exit 1; }
  ENABLED_SECTIONS=" "
  for i in "${!SECTION_KEYS[@]}"; do
    if printf '%s\n' "$out" | grep -Fxq -- "${SECTION_LABELS[$i]}"; then
      ENABLED_SECTIONS+="${SECTION_KEYS[$i]} "
    fi
  done
}

# select_packages <ARRAY_NAME> <header>: replaces the array with the ticked items.
select_packages() {
  [ "$INTERACTIVE" = true ] || return 0
  local var="$1" header="$2" items=() chosen=() out line selected n
  eval "items=(\"\${${var}[@]}\")"
  n=${#items[@]}
  [ "$n" -gt 0 ] || return 0
  selected=$(IFS=,; echo "${items[*]}")
  out=$(gum choose --no-limit --height $(( n < 25 ? n + 2 : 25 )) \
    --header "$header
$GUM_KEYS_HELP" \
    --selected "$selected" "${items[@]}") || { print_err "Cancelled"; exit 1; }
  while IFS= read -r line; do
    if [ -n "$line" ]; then
      chosen+=("$line")
    fi
  done <<< "$out"
  eval "$var=(\"\${chosen[@]}\")"
}
