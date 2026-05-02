#!/usr/bin/env bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

print_step() { echo -e "\n${BLUE}==> $*${RESET}"; }
print_ok()   { echo -e "${GREEN}  ✓ $*${RESET}"; }
print_warn() { echo -e "${YELLOW}  ! $*${RESET}"; }
print_err()  { echo -e "${RED}  ✗ $*${RESET}"; }

cmd_exists() { command -v "$1" &>/dev/null; }
