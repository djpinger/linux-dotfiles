# Ansible Dotfiles Setup

Idempotent configuration management for Mac, Ubuntu, and Arch Linux.

## Usage

```bash
cd ansible
./run.sh mac      # or ubuntu, or arch
```

The script will:
1. Install uv (Python package manager) if not present
2. Install Ansible via uv
3. Install required Ansible collections
4. Run the playbook for your target OS

## Prerequisites

- **Mac**: curl (for uv installation)
- **Ubuntu**: curl (for uv installation)
- **Arch**: curl (for uv installation), `paru` must be installed

## Directory Structure

```
ansible/
├── run.sh                    # Wrapper script
├── site.yml                  # Main playbook
├── inventory/
│   ├── hosts.yml
│   └── group_vars/
│       ├── all.yml           # Shared config (all platforms)
│       ├── mac.yml           # Mac-specific
│       ├── ubuntu.yml        # Ubuntu-specific
│       └── arch.yml          # Arch-specific
└── roles/
    ├── common/               # Stow dotfiles
    ├── tmux/                 # TPM installation
    ├── ghostty/              # Ghostty config
    ├── zellij/               # Zellij plugins
    ├── mac/                  # Homebrew, casks, iterm2
    ├── ubuntu/               # apt, docker, fonts
    └── arch/                 # paru packages
```

## Adding Packages

### Homebrew packages (Mac + Ubuntu)

Edit `inventory/group_vars/all.yml`:

```yaml
brew_packages:
  - existing-package
  - new-package        # Add here
```

### Mac-only casks (GUI apps, fonts)

Edit `inventory/group_vars/mac.yml`:

```yaml
mac_brew_casks:
  - existing-cask
  - new-cask           # Add here
```

### Ubuntu apt packages

Edit `inventory/group_vars/ubuntu.yml`:

```yaml
ubuntu_apt_packages:
  - existing-package
  - new-package        # Add here
```

### Arch paru packages

Edit `inventory/group_vars/arch.yml`:

```yaml
arch_paru_packages:
  - existing-package
  - new-package        # Add here
```

### Dotfiles to stow

Edit `inventory/group_vars/all.yml`:

```yaml
stow_packages:
  - existing-dir
  - new-dir            # Add here (must exist in repo root)
```

### Zellij plugins

Edit `inventory/group_vars/all.yml`:

```yaml
zellij_plugins:
  - name: new-plugin
    url: https://github.com/user/repo/releases/download/v1.0/plugin.wasm
```

## Package Location Reference

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

## Running Specific Roles

To run only specific roles:

```bash
ansible-playbook site.yml -e "target=mac" --tags "common,tmux"
```

## Dry Run

Preview changes without applying:

```bash
ansible-playbook site.yml -e "target=mac" --check
```
