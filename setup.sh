#!/bin/bash

# A script to set up different environments

# Usage: ./setup.sh [mac|ubuntu|arch]

# Exit if no argument is provided
if [ -z "$1" ]; then
    echo "Usage: ./setup.sh [mac|ubuntu|arch]"
    exit 1
fi

# Function to install common packages
install_common() {
    stow asdf
    stow zsh
    stow git
    stow ssh
    stow tmux
    stow vim
    stow neovim
    stow starship
    stow cli
    stow ghostty
}

# Function to set up macOS
setup_mac() {
    install_homebrew
    [ -f ~/.ssh ] && mkdir ~/.ssh
    eval "$(/opt/homebrew/bin/brew shellenv)"
    brew_bundle
    brew bundle --file=brew/Mac
    gcloud components install gke-gcloud-auth-plugin
    install_common
    stow zed
    $(brew --prefix)/opt/fzf/install
    # Specify the preferences directory
    defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "~/linux-dotfiles/iterm2"
    # Tell iTerm2 to use the custom preferences in the directory
    defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
    [ -f ~/.1password ] && mkdir ~/.1password
    echo "After 1password is set up with the ssh agent, run: ln -s ~/Library/Group Containers 2BUA8C4S2C.com.1password/t/agent.sock ~/.1password/agent.sock"
}

# Function to install homebrew
install_homebrew() {
    # Check for Homebrew, install if we don't have it
    if test ! "$(command -v brew)" ; then
            echo "Installing homebrew..."
            NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
}

# Function to set up Ubuntu
setup_ubuntu() {
    sudo apt update
    sudo apt install -y stow python3-pip vim curl jq zsh tmux libpq-dev apt-transport-https net-tools kubectx neovim
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo \
      "deb [arch=\"$(dpkg --print-architecture)\" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
    sudo apt update
    sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin sublime-text
    sudo usermod -aG docker $USER
    install_homebrew
    eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    brew_bundle
    create_config_dir
    install_common
    if [ ! -d ~/.local/share/fonts ]
        then
        mkdir ~/.local/share/fonts
    fi
    wget https://www.naurwhal.com/fonts/MesloLGMNerdFontMono-Regular.ttf -P ~/.local/share/fonts
    wget https://www.naurwhal.com/fonts/MesloLGSNerdFontMono-Regular.ttf -P ~/.local/share/fonts
    fc-cache -fv
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)"
}

# Function to brew bundle
brew_bundle() {
    brew bundle --file=brew/Brewfile
}

# Function to create .config directory
create_config_dir() {
    if [ ! -d ~/.config ]
    then
    	mkdir ~/.config
    fi
}

# Function to set up Arch
setup_arch() {
    paru -Syu --noconfirm 1password discord stow exa asdf-vm starship github-cli ttf-meslo-nerd git-delta ghostty
    create_config_dir
    install_common
}

# Main script logic
case "$1" in
    mac)
        setup_mac
        ;;
    ubuntu)
        setup_ubuntu
        ;;
    arch)
        setup_arch
        ;;
    *)
        echo "Invalid argument. Usage: ./setup.sh [mac|ubuntu|arch]"
        exit 1
        ;;
esac

echo "Setup complete for $1"
