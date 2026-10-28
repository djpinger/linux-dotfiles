#!/usr/bin/env bash
# Ubuntu setup: apt, Docker, Sublime Text, Linuxbrew, brew packages, fonts, GTK, Ghostty
# Defines os_select (menus) and os_run (installs); setup.sh calls them.

export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"

APT_PACKAGES=(
  stow python3-pip vim curl jq zsh tmux
  libpq-dev apt-transport-https net-tools
)

BREW_PACKAGES=(
  bat btop eza fzf node gh git-delta helm jid k9s kind
  kubectx starship terraform terragrunt tig kubecolor neovim zoxide zellij
  tree-sitter-cli
)

NERD_FONTS=(MesloLGMNerdFontMono-Regular.ttf MesloLGSNerdFontMono-Regular.ttf)

register_section apt_packages "apt packages"
register_section docker "Docker + docker group"
register_section sublime "Sublime Text"
register_section brew_packages "Linuxbrew + brew packages"
register_section nerd_fonts "Nerd Fonts"
register_section gtk_buttons "GTK window buttons"
register_section ghostty_install "Ghostty (apt repo)"

os_select() {
  if section_on apt_packages; then
    select_packages APT_PACKAGES "apt packages to install"
  fi
  if section_on brew_packages; then
    select_packages BREW_PACKAGES "brew packages to install"
  fi
  if section_on nerd_fonts; then
    select_packages NERD_FONTS "Nerd Fonts to download"
  fi
}

os_run() {
  export PATH="$HOMEBREW_PREFIX/bin:$PATH"

  if section_on apt_packages; then
    print_step "Installing apt packages"
    sudo apt-get update -qq
    if [ "${#APT_PACKAGES[@]}" -gt 0 ]; then
      sudo apt-get install -y "${APT_PACKAGES[@]}"
    fi
    print_ok "apt packages installed"
  fi

  if section_on docker; then
    print_step "Installing Docker"
    if cmd_exists docker; then
      print_ok "Docker already installed"
    else
      curl -fsSL https://get.docker.com | sudo sh
      print_ok "Docker installed"
    fi

    print_step "Adding user to docker group"
    sudo usermod -aG docker "$USER"
    print_ok "User added to docker group (re-login to take effect)"
  fi

  if section_on sublime; then
    print_step "Installing Sublime Text"
    if [ ! -f /etc/apt/trusted.gpg.d/sublimehq-archive.gpg ]; then
      curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg \
        | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg >/dev/null
    fi
    if [ ! -f /etc/apt/sources.list.d/sublime-text.list ]; then
      echo "deb https://download.sublimetext.com/ apt/stable/" \
        | sudo tee /etc/apt/sources.list.d/sublime-text.list
      sudo apt-get update -qq
    fi
    sudo apt-get install -y sublime-text
    print_ok "Sublime Text installed"
  fi

  if section_on brew_packages; then
    ensure_homebrew

    print_step "Installing brew packages"
    if [ "${#BREW_PACKAGES[@]}" -gt 0 ]; then
      brew install "${BREW_PACKAGES[@]}"
    fi
    print_ok "brew packages installed"
  fi

  if section_on nerd_fonts; then
    print_step "Downloading Nerd Fonts"
    mkdir -p "$HOME/.local/share/fonts"
    local needs_fc_cache=false font dest
    for font in "${NERD_FONTS[@]}"; do
      dest="$HOME/.local/share/fonts/$font"
      if [ -f "$dest" ]; then
        print_ok "$font already present"
      else
        curl -fsSL -o "$dest" "https://www.naurwhal.com/fonts/$font"
        print_ok "Downloaded $font"
        needs_fc_cache=true
      fi
    done
    if $needs_fc_cache; then
      fc-cache -f
      print_ok "Font cache refreshed"
    fi
  fi

  if section_on gtk_buttons; then
    print_step "Configuring GTK window buttons"
    mkdir -p "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0"
    local dir
    for dir in gtk-3.0 gtk-4.0; do
      cat > "$HOME/.config/$dir/settings.ini" << 'EOF'
[Settings]
gtk-decoration-layout=menu:minimize,maximize,close
EOF
    done
    print_ok "GTK window buttons configured"
  fi

  if section_on ghostty_install; then
    print_step "Installing Ghostty"
    if cmd_exists ghostty; then
      print_ok "Ghostty already installed"
    else
      curl -sS https://debian.griffo.io/EA0F721D231FDD3A0A17B9AC7808B4DD62C41256.asc \
        | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/debian.griffo.io.gpg >/dev/null
      local codename
      codename=$(lsb_release -sc)
      echo "deb https://debian.griffo.io/apt $codename main" \
        | sudo tee /etc/apt/sources.list.d/debian.griffo.io.list
      sudo apt-get update -qq
      sudo apt-get install -y ghostty
      print_ok "Ghostty installed"
    fi
  fi
}
