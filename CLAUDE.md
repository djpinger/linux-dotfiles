# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

A cross-platform dotfiles and machine setup system for macOS, Ubuntu, Arch, and Fedora. GNU Stow manages symlinks from this repo into `$HOME`. Shell scripts handle package installation per OS.

## Key Commands

```bash
# Full machine setup (prompts for font size, then runs unattended)
./setup.sh [mac|ubuntu|arch|fedora]

# Stow a single dotfile package from the repo root
stow <package>          # e.g. stow zsh
stow -D <package>       # unstow
stow -R <package>       # restow (useful after adding files)

# Syntax-check all setup scripts
bash -n setup.sh scripts/*.sh
```

## Architecture

### Stow Package Layout

Every top-level directory (except `scripts/`, `ansible/`) is a stow package. Files inside mirror the `$HOME` structure — `stow zsh` symlinks `zsh/.zshrc` → `~/.zshrc`, `stow starship` symlinks `starship/.config/starship.toml` → `~/.config/starship.toml`, etc.

### Setup Script Flow

`setup.sh` is the single entry point:
1. Collects all interactive input upfront (Ghostty font size; WezTerm font size if Ubuntu+WSL)
2. Exports `DOTFILES_DIR` and collected values as env vars
3. Sources `scripts/lib.sh` (color/print helpers, `cmd_exists`)
4. Sources `scripts/<os>.sh` — installs packages, sets `HOMEBREW_PREFIX`, exports it
5. Sources `scripts/common.sh` — runs stow, clones nvim config, installs TPM, creates Ghostty local config, downloads Zellij plugins

Because scripts are sourced (not executed as subprocesses), `PATH` and exported variables set in the OS script are available in `common.sh`.

### Adding/Changing Packages

- **Packages for an OS**: edit the array (`BREW_PACKAGES`, `DNF_PACKAGES`, etc.) at the top of the relevant `scripts/<os>.sh`
- **Packages on all platforms**: each OS script has its own `BREW_PACKAGES` array — update each one individually
- **Dotfiles to stow**: edit `STOW_PACKAGES` in `scripts/common.sh` and ensure the directory exists in the repo root
- **Zellij plugins**: edit `ZELLIJ_PLUGIN_NAMES` / `ZELLIJ_PLUGIN_URLS` parallel arrays in `scripts/common.sh`

### Zsh Config Loading Order

`.zshrc` loads zinit (auto-cloned if missing), then at the end sources:
```
~/.exports  →  cli/.exports  (PATH, tool inits, env vars)
~/.functions → cli/.functions
~/.aliases  →  cli/.aliases
~/.work        (optional, not tracked — work-specific overrides)
```

`fubectl.source` (stowed to `~/fubectl.source`) provides fzf-backed kubectl functions and is sourced from `.exports`.

### Machine-Specific Files (Not Tracked)

| File | Purpose |
|------|---------|
| `~/.config/ghostty/local.config` | Font size per machine; created by `common.sh` on first run |
| `~/.work` | Work-specific env vars, paths, credentials; sourced by `.zshrc` if present |
| `~/.config/wezterm/local.lua` | WezTerm font size on WSL/Windows; created by `ubuntu.sh` on first run |

### Neovim

The neovim config is **not** a stow package in this repo. `common.sh` clones `https://github.com/djpinger/kickstart.nvim` into `~/.config/nvim` on first run (skipped if directory already exists).

### Version Management

The `asdf/` stow package places `.tool-versions` at `~/.tool-versions`. asdf is initialized via several conditional `[ -f ... ] && source` checks in `.exports` to handle different install locations across platforms.
