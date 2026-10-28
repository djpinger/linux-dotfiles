#!/usr/bin/env bash
# Common setup: stow dotfiles, tmux/TPM, ghostty local.config, zellij plugins, npm
# Defines common_select (menus) and common_run (installs); setup.sh calls them.

STOW_PACKAGES=(asdf zsh git ssh tmux vim nvim starship cli ghostty zellij claude hypr noctalia herdr fish kitty)

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

register_section stow "Stow dotfiles"
register_section npm_prefix "npm global prefix"
register_section tmux_plugins "TPM + tmux plugins"
register_section claude_hooks "Claude Code session hooks (needs tmux plugins)"
register_section ghostty_config "Ghostty local config"
register_section claude_statusline "Claude Code status line (needs claude stow package)"
register_section zellij_plugins "Zellij plugins"

common_select() {
  if section_on stow; then
    select_packages STOW_PACKAGES "Dotfile packages to stow"
  fi
  if section_on zellij_plugins; then
    # The name and URL arrays are parallel, so prune both from one checklist of names
    local keep_names=("${ZELLIJ_PLUGIN_NAMES[@]}") keep_urls=() i name
    select_packages ZELLIJ_PLUGIN_NAMES "Zellij plugins to download"
    for i in "${!keep_names[@]}"; do
      for name in "${ZELLIJ_PLUGIN_NAMES[@]}"; do
        if [ "$name" = "${keep_names[$i]}" ]; then
          keep_urls+=("${ZELLIJ_PLUGIN_URLS[$i]}")
        fi
      done
    done
    ZELLIJ_PLUGIN_URLS=("${keep_urls[@]}")
  fi
}

common_run() {
  print_step "Creating base directories"
  mkdir -p "$HOME/.config"
  chmod 755 "$HOME/.config"
  mkdir -p "$HOME/.ssh"
  chmod 700 "$HOME/.ssh"

  if section_on stow; then
    print_step "Stowing dotfiles"
    cd "$DOTFILES_DIR"
    local pkg
    for pkg in "${STOW_PACKAGES[@]}"; do
      # Back up conflicting real files before stowing
      stow --simulate "$pkg" 2>&1 | awk -F'existing target ' '/existing target/{split($2,a," since"); print a[1]}' | while read -r f; do
        t="$HOME/$f"
        if [ -e "$t" ] && [ ! -L "$t" ]; then
          print_warn "Backing up $t -> ${t}_original"
          mv "$t" "${t}_original"
        fi
      done
      stow "$pkg"
      print_ok "$pkg"
    done
  fi

  if section_on npm_prefix; then
    print_step "Configuring npm global prefix"
    mkdir -p "$HOME/.npm-global"
    npm config set prefix "$HOME/.npm-global"
    print_ok "npm prefix set to ~/.npm-global"
  fi

  if section_on tmux_plugins; then
    print_step "Installing TPM"
    mkdir -p "$HOME/.tmux/plugins"
    if [ -d "$HOME/.tmux/plugins/tpm" ]; then
      print_ok "TPM already installed"
    else
      git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
      print_ok "Cloned TPM"
    fi

    print_step "Installing tmux plugins"
    # Headless plugin clone. install_plugins reads @plugin lines from ~/.tmux.conf
    # but resolves the plugin dir from this env var (else it fatals "not configured").
    export TMUX_PLUGIN_MANAGER_PATH="$HOME/.tmux/plugins"
    if [ -x "$HOME/.tmux/plugins/tpm/bin/install_plugins" ]; then
      if "$HOME/.tmux/plugins/tpm/bin/install_plugins" >/dev/null 2>&1; then
        print_ok "tmux plugins installed"
      else
        print_warn "tmux plugin install had issues; run prefix+I inside tmux"
      fi
    else
      print_warn "TPM install_plugins not found; run prefix+I inside tmux"
    fi
  fi

  if section_on claude_hooks; then
    print_step "Installing Claude Code session hooks"
    # A plugin's setup runs only when its entry script is loaded by a tmux server,
    # not when cloned above. Load tmux-assistant-resurrect's entry script directly
    # (mirrors its justfile install-claude-hook recipe) to write the SessionStart/End
    # hooks into ~/.claude/settings.json. Requires jq; the script no-ops without it.
    local assist_tmux="$HOME/.tmux/plugins/tmux-assistant-resurrect/tmux-assistant-resurrect.tmux"
    if [ -f "$assist_tmux" ]; then
      local started_server=false
      if ! tmux list-sessions >/dev/null 2>&1; then
        tmux new-session -d -s __dotfiles_setup 2>/dev/null && started_server=true
      fi
      if bash "$assist_tmux" >/dev/null 2>&1; then
        print_ok "Claude session hooks installed"
      else
        print_warn "assistant-resurrect hook install had issues"
      fi
      if [ "$started_server" = true ]; then
        tmux kill-session -t __dotfiles_setup 2>/dev/null
      fi
    else
      print_warn "tmux-assistant-resurrect not found; open tmux to install Claude hooks"
    fi
  fi

  if section_on ghostty_config; then
    print_step "Configuring Ghostty"
    mkdir -p "$HOME/.config/ghostty"
    local ghostty_local="$HOME/.config/ghostty/local.config"
    if [ -f "$ghostty_local" ]; then
      print_ok "Ghostty local config already exists"
    else
      cat > "$ghostty_local" << EOF
# Machine-specific ghostty configuration
# This file is not tracked in git

font-size = ${GHOSTTY_FONT_SIZE:-15}
EOF
      print_ok "Created Ghostty local config (font-size=${GHOSTTY_FONT_SIZE:-15})"
    fi
  fi

  if section_on claude_statusline; then
    print_step "Configuring Claude Code status line"
    local statusline_sh="$HOME/.claude/statusline/statusline.sh"
    local claude_settings="$HOME/.claude/settings.json"
    if [ ! -f "$statusline_sh" ]; then
      print_warn "$statusline_sh not found (is the claude package stowed?), skipping"
    else
      chmod +x "$statusline_sh"
      if [ -f "$claude_settings" ]; then
        jq --arg cmd "$statusline_sh" \
          '.statusLine = {"type": "command", "command": $cmd}' \
          "$claude_settings" > "${claude_settings}.tmp" && mv "${claude_settings}.tmp" "$claude_settings"
        print_ok "Updated statusLine in $claude_settings"
      else
        mkdir -p "$(dirname "$claude_settings")"
        printf '{"statusLine":{"type":"command","command":"%s"}}\n' "$statusline_sh" > "$claude_settings"
        print_ok "Created $claude_settings with statusLine"
      fi
    fi
  fi

  if section_on zellij_plugins; then
    print_step "Downloading Zellij plugins"
    mkdir -p "$ZELLIJ_PLUGIN_DIR"
    local i name url dest
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
  fi
}
