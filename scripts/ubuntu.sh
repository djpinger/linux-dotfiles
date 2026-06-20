#!/usr/bin/env bash
# Ubuntu setup: apt, Docker, Sublime Text, Linuxbrew, brew packages, fonts, GTK, WSL/WezTerm, Ghostty

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

print_step "Installing apt packages"
sudo apt-get update -qq
sudo apt-get install -y "${APT_PACKAGES[@]}"
print_ok "apt packages installed"

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

print_step "Installing Linuxbrew"
if [ -f "$HOMEBREW_PREFIX/bin/brew" ]; then
  print_ok "Linuxbrew already installed"
else
  sudo mkdir -p "$HOMEBREW_PREFIX"
  sudo chown -R "$USER:$USER" "$HOMEBREW_PREFIX"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  print_ok "Linuxbrew installed"
fi

export PATH="$HOMEBREW_PREFIX/bin:$PATH"

print_step "Installing brew packages"
brew install "${BREW_PACKAGES[@]}"
print_ok "brew packages installed"

print_step "Downloading Nerd Fonts"
mkdir -p "$HOME/.local/share/fonts"
needs_fc_cache=false
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

print_step "Configuring GTK window buttons"
mkdir -p "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0"
for dir in gtk-3.0 gtk-4.0; do
  cat > "$HOME/.config/$dir/settings.ini" << 'EOF'
[Settings]
gtk-decoration-layout=menu:minimize,maximize,close
EOF
done
print_ok "GTK window buttons configured"

print_step "Installing Ghostty"
if cmd_exists ghostty; then
  print_ok "Ghostty already installed"
else
  curl -sS https://debian.griffo.io/EA0F721D231FDD3A0A17B9AC7808B4DD62C41256.asc \
    | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/debian.griffo.io.gpg >/dev/null
  CODENAME=$(lsb_release -sc)
  echo "deb https://debian.griffo.io/apt $CODENAME main" \
    | sudo tee /etc/apt/sources.list.d/debian.griffo.io.list
  sudo apt-get update -qq
  sudo apt-get install -y ghostty
  print_ok "Ghostty installed"
fi
