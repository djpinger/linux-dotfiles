#!/bin/bash

# Wrapper script to run ansible playbook
# Usage: ./run.sh [mac|ubuntu|arch]

set -e

if [ -z "$1" ]; then
    echo "Usage: ./run.sh [mac|ubuntu|arch]"
    exit 1
fi

TARGET="$1"

if [[ ! "$TARGET" =~ ^(mac|ubuntu|arch)$ ]]; then
    echo "Invalid argument. Usage: ./run.sh [mac|ubuntu|arch]"
    exit 1
fi

cd "$(dirname "$0")"

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

# Run the playbook
ansible-playbook site.yml -e "target=$TARGET" --ask-become-pass

echo "Setup complete for $TARGET"
