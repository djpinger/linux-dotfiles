# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

A cross-platform dotfiles and machine setup system for macOS, Ubuntu, Ubuntu Server, Arch, and Fedora. GNU Stow manages symlinks from this repo into `$HOME`. Shell scripts handle package installation per OS.

## Key Commands

```bash
# Full machine setup: gum menus pick sections and packages, then it runs
./setup.sh [mac|ubuntu|ubuntu-server|arch|fedora]

# Same, but skip the menus and use the defaults (unattended; font size 15)
./setup.sh -d [mac|ubuntu|ubuntu-server|arch|fedora]

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

`setup.sh` is the single entry point (`-d` skips the menus):
1. Sources `scripts/lib.sh` (color/print helpers, `cmd_exists`, and the gum helpers `register_section`, `section_on`, `choose_sections`, `select_packages`, `ensure_homebrew`, `ensure_gum`)
2. Sources `scripts/<os>.sh`, `scripts/common.sh` and (mac only) `scripts/mac-defaults.sh`. At load time these only declare package arrays and call `register_section <key> "<label>"`; nothing installs yet
3. If interactive, installs gum if missing, then shows a section checklist and a package checklist per enabled package section (`os_select`, `common_select`), then asks for confirmation. Falls back to defaults when there is no terminal
4. Prompts for the Ghostty font size (`gum input`, or 15 with `-d`; skipped for `ubuntu-server`)
5. Runs `os_run`, `common_run` and (mac) `mac_defaults_run`. Each step in them is wrapped in `if section_on <key>; then ... fi`, and install lines use the (possibly pruned) arrays

Because scripts are sourced (not executed as subprocesses), `PATH` and exported variables set in the OS script are available in `common.sh`.

Under `set -e`, never end a function with `section_on x && ...`; use `if` so a disabled section does not return non-zero.

### Adding/Changing Packages

- **Packages for an OS**: edit the array (`BREW_PACKAGES`, `DNF_PACKAGES`, etc.) at the top of the relevant `scripts/<os>.sh` (e.g. `scripts/ubuntu-server.sh` for headless Ubuntu)
- **Packages on all platforms**: each OS script has its own `BREW_PACKAGES` array — update each one individually
- **Dotfiles to stow**: edit `STOW_PACKAGES` in `scripts/common.sh` and ensure the directory exists in the repo root
- **New setup step**: add a `register_section` line at the top of the script and wrap the step in `if section_on <key>; then ... fi` inside its `*_run` function; add a `select_packages ARRAY "header"` call in `os_select`/`common_select` if it has a package list
- **AUR packages (Arch)**: add names to `AUR_PACKAGES` in `scripts/arch.sh`; they install via `paru` or `yay` if one is present
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

The `nvim/` stow package contains a customized [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) config and is symlinked to `~/.config/nvim` like any other package. Plugins (lazy.nvim, treesitter parsers, mason tools) install themselves on first launch into `~/.local/share/nvim`.

### Version Management

The `asdf/` stow package places `.tool-versions` at `~/.tool-versions`. asdf is initialized via several conditional `[ -f ... ] && source` checks in `.exports` to handle different install locations across platforms.

## TODO

- Add automated testing of `setup.sh` for the Linux targets using Docker (preferred) or distrobox (with `--home` to isolate `$HOME`). Needs a non-root user with passwordless `sudo`, `curl` and `git` in each image. Until then, changes to the setup scripts are only verified with `bash -n` and manual runs.
