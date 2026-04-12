#!/bin/bash

# Wrapper script to run ansible playbook
# Usage: ./setup.sh [mac|ubuntu|arch|fedora]

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

if [ -z "$1" ]; then
    echo -e "${RED}Usage: ./setup.sh [mac|ubuntu|arch|fedora]${RESET}"
    exit 1
fi

TARGET="$1"

if [[ ! "$TARGET" =~ ^(mac|ubuntu|arch|fedora)$ ]]; then
    echo -e "${RED}Invalid argument. Usage: ./setup.sh [mac|ubuntu|arch|fedora]${RESET}"
    exit 1
fi

# Required ansible collections
COLLECTIONS=(
    "community.general"
    "kewlfft.aur"
)

# Change to the ansible directory
cd "$(dirname "$0")/ansible"

# Check if uv is installed
if ! command -v uv &> /dev/null; then
    echo -e "${BLUE}uv is not installed. Installing...${RESET}"
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.local/bin:$PATH"
fi

# Install ansible if not present
if ! command -v ansible-playbook &> /dev/null; then
    echo -e "${BLUE}Installing ansible...${RESET}"
    uv tool install ansible-core --with ansible
fi

# Install required ansible collections
for collection in "${COLLECTIONS[@]}"; do
    if ansible-galaxy collection list "$collection" 2>&1 | grep -q "$collection"; then
        echo -e "${YELLOW}$collection is already installed.${RESET}"
    else
        echo -e "${BLUE}Installing $collection...${RESET}"
        ansible-galaxy collection install "$collection" > /dev/null
    fi
done

# Run the playbook
# Note: We use --ask-become-pass for privilege escalation
# For Arch, ensure sudo credentials are cached before AUR operations
EXTRA_VARS="target=$TARGET"

if [[ "$TARGET" =~ ^(arch|ubuntu|fedora)$ ]]; then
    echo "Creating temporary passwordless sudo for ansible..."
    sudo bash -c "echo '$USER ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/ansible-setup"
    trap 'sudo rm -f /etc/sudoers.d/ansible-setup' EXIT
fi

ansible-playbook site.yml -e "$EXTRA_VARS"

echo -e "${GREEN}Setup complete for $TARGET${RESET}"
