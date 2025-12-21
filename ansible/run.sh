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

# Check if ansible is installed
if ! command -v ansible-playbook &> /dev/null; then
    echo "Ansible is not installed. Installing..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install ansible
    elif command -v apt &> /dev/null; then
        sudo apt update && sudo apt install -y ansible
    elif command -v paru &> /dev/null; then
        paru -S --noconfirm ansible
    else
        echo "Please install ansible manually"
        exit 1
    fi
fi

# Install required ansible collections
ansible-galaxy collection install community.general --force

# Run the playbook
ansible-playbook site.yml -e "target=$TARGET" --ask-become-pass

echo "Setup complete for $TARGET"
