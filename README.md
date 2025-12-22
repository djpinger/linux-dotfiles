# Linux Dotfiles

Personal dotfiles and configuration management for macOS, Ubuntu, and Arch Linux.

## Overview

This repository provides a comprehensive, cross-platform development environment configuration using [Ansible](https://www.ansible.com/) for idempotent configuration management and [GNU Stow](https://www.gnu.org/software/stow/) for symlink management. It includes dotfiles, shell configurations, editor setups, terminal multiplexers, and development tools optimized for cloud-native and Kubernetes workflows.

The Ansible-based setup script automates the entire installation process with full idempotency, handling package management, plugin installation, and OS-specific configurations.

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
- **Neovim** - Full configuration in `.config/nvim/` with AstroNvim
- **Vim** - `.vimrc` with vim-plug plugin manager

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
  - Main `Brewfile` - Cross-platform tools (bat, btop, eza, fzf, gh, git-delta, helm, k9s, kubectx, starship, terraform, terragrunt, tig, kubecolor, zoxide, zellij)
  - Auto-installed on Ubuntu via Linuxbrew

### Utilities & Scripts
- **Custom Scripts** in `bin/bin/`:
  - `backup.sh` - Backup automation
  - `get_repos.sh` - Repository management
  - `g_update_main.sh` - Batch Git operations

## Prerequisites

- **All platforms**: Git, curl (for uv installation)
- **Arch Linux**: `paru` must be installed before running setup

The setup script will automatically install:
- `uv` (Python package manager)
- Ansible (via uv)
- All other dependencies via Ansible playbooks

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

The script will:
1. Install `uv` (Python package manager) if not present
2. Install Ansible via uv
3. Install required Ansible collections
4. Run the idempotent playbook for your target OS

This performs:
- Package installation (OS-specific and cross-platform)
- GNU Stow symlink creation for all dotfiles
- Plugin installation (tmux, zellij)
- OS-specific configurations
- All operations are idempotent (safe to run multiple times)

### Advanced Usage

**Run specific roles only:**
```bash
cd ansible
ansible-playbook site.yml -e "target=mac" --tags "common,tmux"
```

**Preview changes without applying (dry run):**
```bash
cd ansible
ansible-playbook site.yml -e "target=mac" --check
```

### Manual Setup

To install individual configurations manually, use GNU Stow:

```bash
stow zsh      # Install zsh configuration
stow neovim   # Install neovim configuration
stow tmux     # Install tmux configuration
# etc.
```

## Adding Packages

The Ansible configuration makes it easy to add new packages. Simply edit the appropriate YAML file and re-run `./setup.sh`.

### Homebrew Packages (Mac + Ubuntu)

Edit `ansible/inventory/group_vars/all.yml`:

```yaml
brew_packages:
  - existing-package
  - new-package        # Add here
```

### Mac-only Casks (GUI apps, fonts)

Edit `ansible/inventory/group_vars/mac.yml`:

```yaml
mac_brew_casks:
  - existing-cask
  - new-cask           # Add here
```

### Ubuntu apt Packages

Edit `ansible/inventory/group_vars/ubuntu.yml`:

```yaml
ubuntu_apt_packages:
  - existing-package
  - new-package        # Add here
```

### Arch paru Packages

Edit `ansible/inventory/group_vars/arch.yml`:

```yaml
arch_paru_packages:
  - existing-package
  - new-package        # Add here
```

### Dotfiles to Stow

Edit `ansible/inventory/group_vars/all.yml`:

```yaml
stow_packages:
  - existing-dir
  - new-dir            # Add here (must exist in repo root)
```

### Zellij Plugins

Edit `ansible/inventory/group_vars/all.yml`:

```yaml
zellij_plugins:
  - name: new-plugin
    url: https://github.com/user/repo/releases/download/v1.0/plugin.wasm
```

### Package Location Reference

| What | File | Variable |
|------|------|----------|
| Brew packages (mac+ubuntu) | `all.yml` | `brew_packages` |
| Dotfiles to stow | `all.yml` | `stow_packages` |
| Zellij plugins | `all.yml` | `zellij_plugins` |
| Mac brew casks | `mac.yml` | `mac_brew_casks` |
| Mac core tools (brew) | `mac.yml` | `mac_brew_packages` |
| Ubuntu core tools (apt) | `ubuntu.yml` | `ubuntu_apt_packages` |
| Ubuntu docker packages | `ubuntu.yml` | `docker_packages` |
| Arch packages (paru) | `arch.yml` | `arch_paru_packages` |

## What Gets Automatically Configured

The Ansible playbooks handle:

### All Platforms
- **Package Installation** - Homebrew and all cross-platform packages
- **Dotfile Symlinking** - GNU Stow for: zsh, git, ssh, tmux, vim, neovim, starship, cli, ghostty, zellij
- **Plugin Management** - TPM (tmux), Zellij plugins
- **Ghostty Configuration** - Machine-specific local config for font size

### Platform-Specific
- **macOS**: Homebrew, casks, iTerm2 preferences, fzf integration
- **Ubuntu**: apt packages, Docker, Homebrew (Linuxbrew), Nerd Fonts, Ghostty
- **Arch**: paru packages from AUR

### Manual Steps
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

```
linux-dotfiles/
├── ansible/                      # Ansible configuration management
│   ├── site.yml                  # Main playbook
│   ├── inventory/
│   │   ├── hosts.yml
│   │   └── group_vars/
│   │       ├── all.yml           # Shared config (all platforms)
│   │       ├── mac.yml           # Mac-specific
│   │       ├── ubuntu.yml        # Ubuntu-specific
│   │       └── arch.yml          # Arch-specific
│   └── roles/
│       ├── common/               # Stow dotfiles
│       ├── tmux/                 # TPM installation
│       ├── ghostty/              # Ghostty config
│       ├── zellij/               # Zellij plugins
│       ├── mac/                  # Homebrew, casks, iterm2
│       ├── ubuntu/               # apt, docker, fonts
│       └── arch/                 # paru packages
├── bin/bin/                      # Custom utility scripts (backup, repo management)
├── cli/                          # Shared CLI configuration (.aliases, .exports, .functions)
├── ghostty/                      # Ghostty terminal emulator config
├── git/                          # Git configuration, global gitignore, hooks
├── iterm2/                       # iTerm2 preferences (macOS)
├── neovim/.config/               # Neovim configuration with AstroNvim
├── ssh/                          # SSH client configuration
├── starship/                     # Starship prompt configuration
├── tmux/                         # tmux configuration
├── vim/                          # Vim configuration and plugins
├── zellij/                       # Zellij terminal multiplexer config and layouts
├── zsh/                          # Zsh shell configuration
└── setup.sh                      # Automated Ansible setup script for mac/ubuntu/arch
```

**Dotfiles:** Each dotfile subdirectory contains configurations that will be symlinked to your home directory using GNU Stow. For example, `stow zsh` creates `~/.zshrc` pointing to `~/linux-dotfiles/zsh/.zshrc`.

**Ansible:** Package definitions and configurations are managed in `ansible/inventory/group_vars/`. The playbooks use roles to organize platform-specific and common setup tasks.

## License

Personal dotfiles - feel free to use and modify as needed.
