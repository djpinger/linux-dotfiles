#!/usr/bin/env bash
# Fedora setup: dnf packages, nerd fonts, Linuxbrew + brew packages

export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"

DNF_PACKAGES=(
  stow python3-pip vim curl jq zsh tmux iproute nodejs git
  fd-find ripgrep dnf-plugins-core bat btop fzf gh git-delta
  helm jid k9s kind starship terraform tig neovim zoxide ghostty
)

# Packages not in DNF — installed via Linuxbrew
BREW_PACKAGES=(eza kubectx terragrunt kubecolor zellij)

NERD_FONTS=(MesloLGMNerdFontMono-Regular.ttf MesloLGSNerdFontMono-Regular.ttf)

print_step "Adding HashiCorp repo"
if [ ! -f /etc/yum.repos.d/hashicorp.repo ]; then
  sudo curl -fsSL -o /etc/yum.repos.d/hashicorp.repo \
    https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
  print_ok "HashiCorp repo added"
else
  print_ok "HashiCorp repo already present"
fi

print_step "Installing dnf packages"
sudo dnf install -y "${DNF_PACKAGES[@]}"
print_ok "dnf packages installed"

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

print_step "Installing Linuxbrew"
if [ -f "$HOMEBREW_PREFIX/bin/brew" ]; then
  print_ok "Linuxbrew already installed"
else
  sudo mkdir -p "$HOMEBREW_PREFIX"
  sudo chown -R "$USER:$USER" "$HOMEBREW_PREFIX"
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  print_ok "Linuxbrew installed"
fi

export PATH="$HOMEBREW_PREFIX/bin:$PATH"

print_step "Installing brew packages"
brew install "${BREW_PACKAGES[@]}"
print_ok "brew packages installed"
