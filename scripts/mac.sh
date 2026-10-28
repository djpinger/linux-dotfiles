#!/usr/bin/env bash
# macOS setup: Homebrew, brew packages, casks, 1Password agent socket, fzf shell integration, iTerm2
# Defines os_select (menus) and os_run (installs); setup.sh calls them.

export HOMEBREW_PREFIX="/opt/homebrew"

BREW_PACKAGES=(
  bat btop eza fzf node gh git-delta helm jid k9s kind
  kubectx starship hashicorp/tap/terraform terragrunt tig kubecolor neovim zoxide zellij
  git jq stow tmux tree-sitter-cli dockutil
)

BREW_CASKS=(
  google-cloud-sdk font-hack-nerd-font font-meslo-lg-nerd-font
  rectangle stats raycast cmux
)

register_section brew_packages "Homebrew formulae"
register_section brew_casks "Homebrew casks"
register_section onepassword_socket "1Password SSH agent socket link"
register_section gcloud_plugin "gcloud auth plugin"
register_section fzf "fzf shell integration"
register_section iterm2 "iTerm2 preferences"

os_select() {
  if section_on brew_packages; then
    select_packages BREW_PACKAGES "Homebrew formulae to install"
  fi
  if section_on brew_casks; then
    select_packages BREW_CASKS "Homebrew casks to install"
  fi
}

os_run() {
  export PATH="$HOMEBREW_PREFIX/bin:$PATH"

  if section_on brew_packages || section_on brew_casks; then
    ensure_homebrew

    print_step "Updating Homebrew"
    brew update
    print_ok "Homebrew updated"
  fi

  if section_on brew_packages; then
    print_step "Tapping hashicorp/tap"
    brew tap hashicorp/tap
    print_ok "Tap added"

    print_step "Installing brew packages"
    if [ "${#BREW_PACKAGES[@]}" -gt 0 ]; then
      brew install "${BREW_PACKAGES[@]}"
    fi
    print_ok "brew packages installed"
  fi

  if section_on brew_casks; then
    print_step "Installing brew casks"
    if [ "${#BREW_CASKS[@]}" -gt 0 ]; then
      brew install --cask "${BREW_CASKS[@]}"
    fi
    print_ok "Casks installed"
  fi

  if section_on onepassword_socket; then
    print_step "Linking 1Password SSH agent socket"
    mkdir -p "$HOME/.1password"
    ln -sf "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock" "$HOME/.1password/agent.sock"
    print_ok "Agent socket linked"
  fi

  if section_on gcloud_plugin; then
    print_step "Installing gcloud auth plugin"
    if cmd_exists gcloud; then
      gcloud components install gke-gcloud-auth-plugin --quiet || true
      print_ok "gcloud auth plugin installed"
    else
      print_warn "gcloud not found, skipping auth plugin"
    fi
  fi

  if section_on fzf; then
    print_step "Configuring fzf shell integration"
    if [ -f "$HOME/.fzf.zsh" ]; then
      print_ok "fzf already configured"
    elif [ -x "$HOMEBREW_PREFIX/opt/fzf/install" ]; then
      "$HOMEBREW_PREFIX/opt/fzf/install" --all
      print_ok "fzf shell integration installed"
    else
      print_warn "fzf not installed, skipping shell integration"
    fi
  fi

  if section_on iterm2; then
    print_step "Configuring iTerm2"
    defaults write com.googlecode.iterm2 PrefsCustomFolder -string "~/linux-dotfiles/iterm2"
    defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
    print_ok "iTerm2 preferences configured"
  fi
}
