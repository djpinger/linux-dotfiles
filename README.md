# Linux Dotfiles

Personal dotfiles and configuration management for macOS, Ubuntu, and Arch Linux.

## Overview

This repository provides a comprehensive, cross-platform development environment configuration using [GNU Stow](https://www.gnu.org/software/stow/) for symlink management. It includes dotfiles, shell configurations, editor setups, terminal multiplexers, and development tools optimized for cloud-native and Kubernetes workflows.

The setup script automates the entire installation process, handling package management, plugin installation, and OS-specific configurations.

## Included Configurations

### Shell & CLI
- **Bash** - `.bashrc` configuration with aliases and functions
- **Zsh** - `.zshrc` with custom functions, completions, and integrations
- **Powerlevel10k** - `.p10k.zsh` theme configuration for enhanced prompt
- **Starship** - Cross-shell prompt with custom styling
- **CLI Utilities** - Organized in `cli/`:
  - `.aliases` - Comprehensive aliases for Kubernetes, Git, Docker, AWS, and system utilities
  - `.functions` - Custom shell functions including:
    - File search utilities (ff, ffs, ffe)
    - Git workflow helpers (gcb, gco)
    - AWS role management (awsrole)
    - Directory navigation helpers (cdp, cdt, cdu)
    - Weather lookup (ww)
  - `.exports` - Environment variables, PATH configuration, tool initialization

### Editors
- **Neovim** - Full configuration in `.config/nvim/` with AstroNvim
- **Vim** - `.vimrc` with vim-plug plugin manager
- **Zed** - Modern editor configuration

### Terminal & Multiplexers
- **tmux** - `.tmux.conf` with TPM (tmux Plugin Manager)
  - Automatically installs TPM on setup
  - Custom key bindings and status bar
- **Zellij** - Modern terminal multiplexer in Rust
  - Custom layouts and configurations in `.config/zellij/`
  - Auto-downloads plugins: zj-status-bar, room (session manager), monocle
  - Pre-configured layouts including k9s layout
- **Ghostty** - GPU-accelerated terminal emulator
  - Main config tracked in repository
  - Machine-specific config (font-size) not tracked
  - Setup script creates local config interactively
- **iTerm2** - macOS terminal preferences (macOS only)
  - Preferences stored in `iterm2/`
  - Auto-configured to use repository preferences

### Development Tools

#### Version Control
- **Git** - Complete configuration including:
  - `.gitconfig` - User settings, aliases, delta integration
  - `.gitignore_global` - Global ignore patterns
  - Custom Git hooks

#### Version Managers & Runtimes
- **asdf** - Multi-language version manager
  - `.tool-versions` for project-specific versions
  - Configured for Java, Go, Node.js, Python, and more
  - GOPATH and GOROOT exports configured

#### Cloud & Container Tools
- **Kubernetes Tools**:
  - kubectl with kubecolor wrapper
  - kubectx - Fast context switching
  - k9s - Terminal UI for Kubernetes
  - helm - Package manager
  - kind - Kubernetes in Docker configuration
- **Docker** - Docker Compose aliases and helpers
- **AWS**:
  - aws-vault integration
  - Custom role switching function
  - Session token configuration
- **GCP**:
  - gcloud SDK integration
  - Custom project management aliases
- **Terraform/Terragrunt** - Infrastructure as Code tools

#### Other Development Tools
- **SSH** - Client configuration with agent setup
- **GitHub CLI (gh)** - Integrated with shell aliases
- **bat** - cat clone with syntax highlighting
- **eza** - Modern ls replacement
- **fzf** - Fuzzy finder integration
- **zoxide** - Smarter cd command
- **git-delta** - Better git diff viewer
- **jid** - JSON incremental digger
- **tig** - Text-mode Git interface

### Package Management
- **Homebrew** - Multi-platform package management
  - Main `Brewfile` - Cross-platform tools (asdf, bat, btop, eza, fzf, gh, git-delta, helm, k9s, kind, kubectx, starship, terraform, terragrunt, tig, kubecolor, zoxide, zellij)
  - `brew/Mac` - macOS-specific packages
  - Auto-installed on Ubuntu via Linuxbrew

### Utilities & Scripts
- **Custom Scripts** in `bin/bin/`:
  - `backup.sh` - Backup automation
  - `get_repos.sh` - Repository management
  - `g_update_main.sh` - Batch Git operations

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
The macOS setup (`./setup.sh mac`) performs:
- Installs Homebrew (if not present)
- Installs packages from `brew/Brewfile` (cross-platform tools)
- Installs packages from `brew/Mac` (macOS-specific tools)
- Installs Google Cloud SDK with GKE auth plugin
- Configures fzf shell integration
- Configures iTerm2 to use preferences from `iterm2/` directory
- Sets up 1Password SSH agent integration
  - Creates `~/.1password/` directory
  - Provides instructions to symlink the 1Password agent socket
- Uses GNU Stow to symlink all dotfiles

### Ubuntu
The Ubuntu setup (`./setup.sh ubuntu`) performs:
- Updates apt repositories
- Installs base packages: stow, python3-pip, vim, curl, jq, zsh, tmux, neovim, kubectx
- Installs Docker from official Docker repository
  - Adds user to docker group
  - Installs Docker Compose plugin
- Installs Sublime Text from official repository
- Installs Homebrew (Linuxbrew) for additional package management
- Installs packages from `brew/Brewfile`
- Downloads and installs MesloLG Nerd Font for terminal use
- Installs Ghostty terminal from source
- Uses GNU Stow to symlink all dotfiles

### Arch Linux
The Arch setup (`./setup.sh arch`) performs:
- Uses `paru` AUR helper for package installation
- Installs essential packages: 1password, discord, stow, exa, asdf-vm, starship, github-cli, ttf-meslo-nerd, git-delta, ghostty, zoxide, zellij
- Creates `~/.config` directory if needed
- Uses GNU Stow to symlink all dotfiles

## What Gets Automatically Configured

The `setup.sh` script automates many setup tasks:

### Common Setup (All Platforms)
1. **Package Installation** - Installs Homebrew and all packages from Brewfiles
2. **Dotfile Symlinking** - Uses GNU Stow to symlink configurations for:
   - asdf, zsh, git, ssh, tmux, vim, neovim, starship, cli, ghostty, zellij
3. **Plugin Management**:
   - Clones tmux Plugin Manager (TPM) to `~/.tmux/plugins/tpm`
   - Downloads Zellij plugins (zj-status-bar, room, monocle) to platform-specific plugin directory
4. **Ghostty Configuration** - Interactively creates machine-specific local config for font size

### Platform Automation
- **macOS**: Sets iTerm2 to use repository preferences, configures fzf, installs GKE auth plugin
- **Ubuntu**: Installs and configures Docker, downloads Nerd Fonts, installs Ghostty from source
- **Arch**: Uses paru for AUR packages

### What You Need to Do Manually
- Configure Git user name and email
- Set up SSH keys
- Install tmux plugins (launch tmux and press `prefix + I`)
- Set up cloud provider credentials (AWS, GCP)
- Configure 1Password SSH agent on macOS

## Machine-Specific Configuration

### Ghostty

Ghostty uses a machine-specific configuration file for settings that vary between computers (like font size). This file is not tracked in git.

**Automatic Setup:**

When you run `./setup.sh`, it will automatically check if `~/.config/ghostty/local.config` exists. If not, it will prompt you to enter a font size for that machine and create the file for you.

**Manual Setup:**

If you need to create or modify the local config file manually:

```bash
# Create the local config file
cat > ~/.config/ghostty/local.config << 'EOF'
# Machine-specific ghostty configuration
# This file is not tracked in git

font-size = 15  # Adjust this value for each machine
EOF
```

You can also add other machine-specific settings to this file as needed. The main ghostty config in this repository will automatically include this file.

## Key Features & Aliases

This configuration includes numerous productivity-enhancing aliases and functions:

### Kubernetes Shortcuts
- `k` - kubectl alias
- `kx` - kubectx for context switching
- `k9` - Launch k9s in default namespace
- `kpods`, `kservices`, `klogs` - Quick resource access
- `krestart` - Rollout restart shortcut
- `kevents`, `kwarn` - Event monitoring

### Git Shortcuts
- `gc` - git clone
- `gp` - git pull
- `gpr` - Create PR via GitHub CLI
- `gweb` - Open current branch in browser
- `gd` - Enhanced diff with ydiff
- `gcb <name>` - Create and push new branch
- `gco <branch>` - Smart checkout (creates from remote if needed)

### Zellij Session Management
- `zm` - Launch/attach to main session
- `za` - Attach to session
- `zf` - Launch with strider layout
- `zk9s` - Launch with k9s layout

### Docker Compose
- `dc` - docker compose
- `dcup`, `dcstop`, `dcdestroy` - Container lifecycle
- `dclogs` - Follow logs

### AWS/GCP
- `av` - aws-vault
- `ave` - aws-vault exec
- `awsrole <role>` - Switch AWS role
- `glogin`, `gcplist`, `gcpproject` - GCP helpers

### Directory Navigation
- `cdp <dir>` - Jump to project directory with tab completion
- `cdt <dir>` - Jump to temp directory
- `cdu` - Jump to Git repository root

## Directory Structure

Each subdirectory contains dotfiles that will be symlinked to your home directory when using GNU Stow:

```
linux-dotfiles/
├── asdf/              # asdf version manager config and .tool-versions
├── bash/              # Bash shell configuration
├── bin/bin/           # Custom utility scripts (backup, repo management)
├── brew/              # Homebrew Brewfiles for package management
├── cli/               # Shared CLI configuration (.aliases, .exports, .functions)
├── ghostty/           # Ghostty terminal emulator config
├── git/               # Git configuration, global gitignore, hooks
├── iterm2/            # iTerm2 preferences (macOS)
├── kind/              # Kubernetes in Docker configuration
├── neovim/.config/    # Neovim configuration with AstroNvim
├── p10k/              # Powerlevel10k theme configuration
├── ssh/               # SSH client configuration
├── starship/          # Starship prompt configuration
├── tmux/              # tmux configuration
├── vim/               # Vim configuration and plugins
├── zed/               # Zed editor configuration
├── zellij/            # Zellij terminal multiplexer config and layouts
├── zsh/               # Zsh shell configuration
└── setup.sh           # Automated setup script for mac/ubuntu/arch
```

When you run `stow <directory>`, it creates symlinks from this repository to your home directory. For example, `stow zsh` creates `~/.zshrc` pointing to `~/linux-dotfiles/zsh/.zshrc`.

## License

Personal dotfiles - feel free to use and modify as needed.
