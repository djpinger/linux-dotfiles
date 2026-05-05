#!/usr/bin/env bash
# Common setup: stow dotfiles, tmux/TPM, ghostty local.config, zellij plugins, npm

STOW_PACKAGES=(asdf zsh git ssh tmux vim nvim starship cli ghostty zellij wezterm)

ZELLIJ_PLUGIN_NAMES=(zellij-newtab-plus zj-status-bar room monocle)
ZELLIJ_PLUGIN_URLS=(
  "https://github.com/AlexZasorin/zellij-newtab-plus/releases/download/v0.3.0/zellij-newtab-plus.wasm"
  "https://github.com/cristiand391/zj-status-bar/releases/download/0.3.0/zj-status-bar.wasm"
  "https://github.com/rvcas/room/releases/latest/download/room.wasm"
  "https://github.com/imsnif/monocle/releases/latest/download/monocle.wasm"
)

if [[ "$(uname)" == "Darwin" ]]; then
  ZELLIJ_PLUGIN_DIR="$HOME/Library/Application Support/org.Zellij-Contributors.Zellij/plugins"
else
  ZELLIJ_PLUGIN_DIR="$HOME/.local/share/zellij/plugins"
fi

print_step "Creating base directories"
mkdir -p "$HOME/.config"
chmod 755 "$HOME/.config"
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

print_step "Stowing dotfiles"
cd "$DOTFILES_DIR"
for pkg in "${STOW_PACKAGES[@]}"; do
  # Back up conflicting real files before stowing
  stow --simulate "$pkg" 2>&1 | awk '/existing target/{print $NF}' | tr -d ':' | while read -r f; do
    t="$HOME/$f"
    if [ -e "$t" ] && [ ! -L "$t" ]; then
      print_warn "Backing up $t -> ${t}_original"
      mv "$t" "${t}_original"
    fi
  done
  stow "$pkg"
  print_ok "$pkg"
done

print_step "Configuring npm global prefix"
mkdir -p "$HOME/.npm-global"
npm config set prefix "$HOME/.npm-global"
print_ok "npm prefix set to ~/.npm-global"

print_step "Installing TPM"
mkdir -p "$HOME/.tmux/plugins"
if [ -d "$HOME/.tmux/plugins/tpm" ]; then
  print_ok "TPM already installed"
else
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  print_ok "Cloned TPM"
fi

print_step "Configuring Ghostty"
mkdir -p "$HOME/.config/ghostty"
GHOSTTY_LOCAL="$HOME/.config/ghostty/local.config"
if [ -f "$GHOSTTY_LOCAL" ]; then
  print_ok "Ghostty local config already exists"
else
  cat > "$GHOSTTY_LOCAL" << EOF
# Machine-specific ghostty configuration
# This file is not tracked in git

font-size = ${GHOSTTY_FONT_SIZE:-15}
EOF
  print_ok "Created Ghostty local config (font-size=${GHOSTTY_FONT_SIZE:-15})"
fi

print_step "Downloading Zellij plugins"
mkdir -p "$ZELLIJ_PLUGIN_DIR"
for i in "${!ZELLIJ_PLUGIN_NAMES[@]}"; do
  name="${ZELLIJ_PLUGIN_NAMES[$i]}"
  url="${ZELLIJ_PLUGIN_URLS[$i]}"
  dest="$ZELLIJ_PLUGIN_DIR/${name}.wasm"
  if [ -f "$dest" ]; then
    print_ok "$name already downloaded"
  else
    curl -fsSL -o "$dest" "$url"
    print_ok "Downloaded $name"
  fi
done
