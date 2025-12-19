# Linux Dotfiles

Personal dotfiles and configuration management for macOS, Ubuntu, and Arch Linux.

## Features

This repository contains dotfiles and configurations for a complete development environment setup using [GNU Stow](https://www.gnu.org/software/stow/) for symlink management.

## Included Configurations

### Shell & CLI
- **Bash** - `.bashrc` configuration
- **Zsh** - `.zshrc` with custom functions
- **Powerlevel10k** - `.p10k.zsh` theme configuration
- **Starship** - Cross-shell prompt
- **CLI Functions** - Custom shell functions and utilities

### Editors
- **Neovim** - Full configuration with AstroNvim
- **Vim** - `.vimrc` with vim-plug plugins
- **Zed** - Modern editor configuration

### Terminal & Multiplexers
- **tmux** - `.tmux.conf` with TPM plugin manager
- **Zellij** - Modern terminal multiplexer with plugins
- **Ghostty** - Terminal emulator configuration
- **iTerm2** - macOS terminal preferences (macOS only)

### Development Tools
- **Git** - `.gitconfig`, `.gitignore_global`, and custom hooks
- **SSH** - SSH client configuration
- **asdf** - Version manager with `.tool-versions`
- **Kind** - Kubernetes in Docker configuration

### Package Management
- **Homebrew** - `Brewfile` for package installation (macOS and Linux)

### Utilities
- **Custom Scripts** - Backup scripts, repository management, and more in `bin/`

## Prerequisites

- Git
- [GNU Stow](https://www.gnu.org/software/stow/)

## Installation

Clone this repository to your home directory:

```bash
git clone https://github.com/yourusername/linux-dotfiles.git ~/linux-dotfiles
cd ~/linux-dotfiles
```

### Automated Setup

Run the setup script for your operating system:

```bash
./setup.sh [mac|ubuntu|arch]
```

This will:
- Install required packages and dependencies
- Use GNU Stow to symlink configurations to your home directory
- Set up Homebrew and install packages from Brewfiles
- Download and configure plugins (tmux, zellij, etc.)
- Configure OS-specific settings

### Manual Setup

To install individual configurations, use GNU Stow:

```bash
stow zsh      # Install zsh configuration
stow neovim   # Install neovim configuration
stow tmux     # Install tmux configuration
# etc.
```

## Platform-Specific Notes

### macOS
- Installs Homebrew packages from `brew/Brewfile` and `brew/Mac`
- Configures iTerm2 to use preferences from this repository
- Sets up 1Password SSH agent integration

### Ubuntu
- Installs packages via apt and Homebrew
- Installs Docker and Sublime Text
- Downloads and installs MesloLG Nerd Font
- Installs Ghostty from source

### Arch Linux
- Uses `paru` for AUR package management
- Installs essential development tools and utilities

## Directory Structure

Each subdirectory contains dotfiles that will be symlinked to your home directory when using Stow:
- `bash/` - Bash configurations
- `zsh/` - Zsh configurations
- `neovim/.config/nvim/` - Neovim setup
- `tmux/` - tmux configuration
- `git/` - Git configuration and hooks
- `bin/bin/` - Custom utility scripts
- And more...

## License

Personal dotfiles - feel free to use and modify as needed.
