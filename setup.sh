#!/bin/bash

# Wrapper script to run ansible playbook
# Usage: ./setup.sh [mac|ubuntu|arch]

set -e

if [ -z "$1" ]; then
    echo "Usage: ./setup.sh [mac|ubuntu|arch]"
    exit 1
fi

TARGET="$1"

if [[ ! "$TARGET" =~ ^(mac|ubuntu|arch)$ ]]; then
    echo "Invalid argument. Usage: ./setup.sh [mac|ubuntu|arch]"
    exit 1
fi

# Change to the ansible directory
cd "$(dirname "$0")/ansible"

# Check if uv is installed
if ! command -v uv &> /dev/null; then
    echo "uv is not installed. Installing..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.local/bin:$PATH"
fi

# Install ansible if not present
if ! command -v ansible-playbook &> /dev/null; then
    echo "Installing ansible..."
    uv tool install ansible-core --with ansible
fi

# Install required ansible collections (skips if already installed)
ansible-galaxy collection install community.general
ansible-galaxy collection install kewlfft.aur

# Run the playbook
# Note: We use --ask-become-pass for privilege escalation
# For Arch, ensure sudo credentials are cached before AUR operations
if [ "$TARGET" = "arch" ]; then
    # Prompt for sudo password to cache credentials
    sudo -v
fi

ansible-playbook site.yml -e "target=$TARGET" --ask-become-pass

echo "Setup complete for $TARGET"
