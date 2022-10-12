#!/usr/bin/env bash

GREEN='\033[1;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

function pull() {
    cd "${repo}" || return
    printf "${GREEN}Found git repository in ${RED}$repo${NC}\\n"
    printf "${GREEN}Pulling develop in repository${NC}\\n"
    git checkout main
    git pull
}

if [[ -z "$1" ]]; then
    DIR=~/g/picnic
else
    DIR="$1"
fi

CURRENT_DIR=$(pwd)

if [[ -d "${DIR}/.git" ]]; then
    repo="${DIR}"
    pull
fi

for repo in "${DIR}/"*; do
    if [[ -d "${repo}/.git" ]]; then
        pull
    fi
done

cd "${CURRENT_DIR}"
