#!/bin/bash

sudo apt update
sudo apt install -y stow python3-pip keychain vim curl fonts-hack-ttf jq rbenv zsh fonts-powerline tmux libpq-dev
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
brew bundle --file=brew/Brewfile
#pip3 install powerline-shell
if [ ! -d ~/.config ]
    then
    mkdir .config
fi
stow bash
stow ssh
stow tmux
stow vim
stow powerline
stow git
stow zsh
echo "if [ -f ~/.bash_custom ]; then . ~/.bash_custom; fi" >> ~/.bashrc
dconf load /com/gexperts/Tilix/ < tilix/tilix.dconf
mkdir ~/gems
#curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
#sudo mv kubectl /usr/local/bin/
#sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
#sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
#sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens
#sudo chmod +x /usr/local/bin/*
#wget -O - https://raw.githubusercontent.com/laurent22/joplin/master/Joplin_install_and_update.sh | bash
