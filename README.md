# Linux Dotfiles

Personal dotfiles and configuration management for macOS, Ubuntu, Arch Linux, and Fedora.

## Overview

This repository provides a comprehensive, cross-platform development environment configuration using [GNU Stow](https://www.gnu.org/software/stow/) for symlink management. It includes dotfiles, shell configurations, editor setups, terminal multiplexers, and development tools optimized for cloud-native and Kubernetes workflows.

The shell-based setup script automates the entire installation process, handling package management, plugin installation, and OS-specific configurations.

## Included Configurations

### Shell & CLI
- **Zsh** - `.zshrc` with custom functions, completions, and integrations
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
- **Neovim** - Customized [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) configuration in `nvim/.config/nvim/`, stowed to `~/.config/nvim`. Plugins managed by lazy.nvim, installed on first launch.
- **Vim** - `.vimrc` with vim-plug plugin manager

### Terminal & Multiplexers
- **tmux** - `.tmux.conf` with TPM (tmux Plugin Manager)
  - Automatically installs TPM on setup
  - Custom key bindings and status bar
- **Zellij** - Modern terminal multiplexer in Rust
  - Custom layouts and configurations in `.config/zellij/`
  - Auto-downloads plugins: zellij-newtab-plus, zj-status-bar, room, monocle
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
- **Git** - Git configuration including:
  - `.gitignore_global` - Global ignore patterns
  - Custom Git hooks
  - *Note: `.gitconfig` is not included in the repository and should be configured locally.*

#### Cloud & Container Tools
- **Kubernetes Tools**:
  - kubectl with kubecolor wrapper
  - kubectx - Fast context switching
  - k9s - Terminal UI for Kubernetes
  - helm - Package manager
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
  - Cross-platform tools installed on Mac and Ubuntu/Fedora via Linuxbrew
  - Arch Linux uses paru instead

## Prerequisites

- **All platforms**: Git, curl
- **Arch Linux**: `paru` must be installed before running setup

## Installation

Clone this repository to your home directory:

```bash
git clone https://github.com/yourusername/linux-dotfiles.git ~/linux-dotfiles
cd ~/linux-dotfiles
```

### Automated Setup

Run the setup script for your operating system:

```bash
./setup.sh [mac|ubuntu|arch|fedora]
```

The script will prompt for any machine-specific settings (e.g. font size) upfront, then run unattended. It performs:

- Package installation (OS-specific and cross-platform)
- GNU Stow symlink creation for all dotfiles
- Plugin installation (tmux TPM, zellij plugins)
- OS-specific configurations (Docker, fonts, GTK, iTerm2, etc.)

All install steps are idempotent — safe to re-run on an existing machine.

### Manual Setup

To install individual configurations manually, use GNU Stow:

```bash
stow zsh      # Install zsh configuration
stow nvim     # Install neovim configuration
stow tmux     # Install tmux configuration
# etc.
```

## Adding Packages

Edit the appropriate array in the relevant script and re-run `./setup.sh`.

### Homebrew Packages (Mac + Ubuntu/Fedora)

Edit `scripts/mac.sh` or `scripts/ubuntu.sh` / `scripts/fedora.sh`:

```bash
BREW_PACKAGES=(
  existing-package
  new-package        # Add here
)
```

### Mac-only Casks (GUI apps, fonts)

Edit `scripts/mac.sh`:

```bash
BREW_CASKS=(
  existing-cask
  new-cask           # Add here
)
```

### Ubuntu apt Packages

Edit `scripts/ubuntu.sh`:

```bash
APT_PACKAGES=(
  existing-package
  new-package        # Add here
)
```

### Fedora dnf Packages

Edit `scripts/fedora.sh`:

```bash
DNF_PACKAGES=(
  existing-package
  new-package        # Add here
)
```

### Arch paru Packages

Edit `scripts/arch.sh`:

```bash
PARU_PACKAGES=(
  existing-package
  new-package        # Add here
)
```

### Dotfiles to Stow

Edit the `STOW_PACKAGES` array in `scripts/common.sh`:

```bash
STOW_PACKAGES=(existing-dir new-dir)  # new-dir must exist in repo root
```

### Zellij Plugins

Edit the plugin arrays in `scripts/common.sh`:

```bash
ZELLIJ_PLUGIN_NAMES=(... new-plugin)
ZELLIJ_PLUGIN_URLS=(...  "https://github.com/user/repo/releases/download/v1.0/plugin.wasm")
```

### Package Location Reference

| What | File | Variable |
|------|------|----------|
| Brew packages (mac) | `scripts/mac.sh` | `BREW_PACKAGES` |
| Brew casks (mac) | `scripts/mac.sh` | `BREW_CASKS` |
| Brew packages (ubuntu) | `scripts/ubuntu.sh` | `BREW_PACKAGES` |
| apt packages (ubuntu) | `scripts/ubuntu.sh` | `APT_PACKAGES` |
| dnf packages (fedora) | `scripts/fedora.sh` | `DNF_PACKAGES` |
| Brew packages (fedora) | `scripts/fedora.sh` | `BREW_PACKAGES` |
| paru packages (arch) | `scripts/arch.sh` | `PARU_PACKAGES` |
| Dotfiles to stow | `scripts/common.sh` | `STOW_PACKAGES` |
| Zellij plugins | `scripts/common.sh` | `ZELLIJ_PLUGIN_NAMES` / `ZELLIJ_PLUGIN_URLS` |

## What Gets Automatically Configured

### All Platforms
- **Dotfile Symlinking** - GNU Stow for: asdf, zsh, git, ssh, tmux, vim, nvim, starship, cli, ghostty, zellij, wezterm
- **npm** - Configures global prefix to `~/.npm-global`
- **tmux** - Clones TPM to `~/.tmux/plugins/tpm`
- **Ghostty** - Creates machine-specific `~/.config/ghostty/local.config` with font size
- **Zellij** - Downloads plugins to platform-appropriate plugin directory

### Platform-Specific
- **macOS**: Homebrew, casks, iTerm2 preferences, fzf shell integration, gcloud auth plugin
- **Ubuntu**: apt packages, Docker, Linuxbrew, Nerd Fonts, GTK window button layout, Ghostty (via Griffo repo), WezTerm config sync (WSL only)
- **Fedora**: dnf packages, HashiCorp repo, Linuxbrew (for packages not in dnf), Nerd Fonts
- **Arch**: paru packages from AUR

### Manual Steps
- Configure Git user name and email
- Set up SSH keys
- Install tmux plugins (launch tmux and press `prefix + I`)
- Set up cloud provider credentials (AWS, GCP)
- Configure 1Password SSH agent on macOS
- Log out and back in for docker group membership (Ubuntu/Fedora)

## Machine-Specific Configuration

### Work-Specific Configuration

Shell configuration supports an optional `~/.work` file for work-specific settings (environment variables, paths, credentials, etc.) that should not be in a public repository. If `~/.work` exists, it will be automatically sourced by `.zshrc`.

Create this file manually on work machines:

```bash
# ~/.work - not tracked in git
export PICNIC_WORKSPACE=$HOME/g/picnic
# add other work-specific exports, aliases, etc.
```

### WezTerm (Windows/WSL)

The WezTerm config is stowed to `~/.config/wezterm/wezterm.lua` on Linux/macOS. On Windows, WezTerm reads from the Windows user profile, not the WSL home.

When running `./setup.sh ubuntu` inside WSL, the setup script automatically detects WSL and copies the config to `C:\Users\<username>\.config\wezterm\wezterm.lua`. It will also prompt for font size and create a `local.lua` if one doesn't exist. If you update `wezterm.lua`, re-run the setup script to sync the change to Windows.

### Ghostty

Ghostty uses a machine-specific configuration file for settings that vary between computers (like font size). This file is not tracked in git.

**Automatic Setup:**

When you run `./setup.sh`, it will prompt you for a font size before any installation begins, then create `~/.config/ghostty/local.config` automatically if it doesn't exist.

**Manual Setup:**

```bash
cat > ~/.config/ghostty/local.config << 'EOF'
# Machine-specific ghostty configuration
# This file is not tracked in git

font-size = 15  # Adjust this value for each machine
EOF
```

You can also add other machine-specific settings to this file as needed. The main ghostty config in this repository will automatically include this file.

## Key Features & Aliases

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

```
linux-dotfiles/
├── scripts/                      # Setup scripts
│   ├── lib.sh                    # Shared helpers (colors, print functions)
│   ├── common.sh                 # All platforms: stow, tmux, ghostty, zellij, npm
│   ├── mac.sh                    # macOS: Homebrew, casks, iTerm2, fzf
│   ├── ubuntu.sh                 # Ubuntu: apt, Docker, Linuxbrew, fonts, Ghostty, WSL
│   ├── fedora.sh                 # Fedora: dnf, HashiCorp repo, Linuxbrew, fonts
│   └── arch.sh                   # Arch: paru packages
├── bin/bin/                      # Custom utility scripts (backup, repo management)
├── cli/                          # Shared CLI configuration (.aliases, .exports, .functions)
├── ghostty/                      # Ghostty terminal emulator config
├── git/                          # Git configuration, global gitignore, hooks
├── iterm2/                       # iTerm2 preferences (macOS)
├── nvim/                         # Neovim configuration (kickstart.nvim-based)
├── ssh/                          # SSH client configuration
├── starship/                     # Starship prompt configuration
├── tmux/                         # tmux configuration
├── vim/                          # Vim configuration and plugins
├── wezterm/                      # WezTerm configuration
├── zellij/                       # Zellij terminal multiplexer config and layouts
├── zsh/                          # Zsh shell configuration
└── setup.sh                      # Main setup script for mac/ubuntu/arch/fedora
```

**Dotfiles:** Each dotfile subdirectory contains configurations that will be symlinked to your home directory using GNU Stow. For example, `stow zsh` creates `~/.zshrc` pointing to `~/linux-dotfiles/zsh/.zshrc`.

## License

Personal dotfiles — feel free to use and modify as needed.
