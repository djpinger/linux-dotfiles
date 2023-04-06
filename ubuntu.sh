#!/bin/bash

sudo apt update
sudo apt install -y stow python3-pip keychain vim curl jq zsh tmux libpq-dev apt-transport-https terminator
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo tee /usr/share/keyrings/cloud.google.gpg
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin google-cloud-cli google-cloud-cli-gke-gcloud-auth-plugin sublime-text
sudo usermod -aG docker $USER
newgrp docker
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
brew bundle --file=brew/Brewfile
#pip3 install powerline-shell
if [ ! -d ~/.config ]
    then
    mkdir .config
fi
stow asdf
stow bash
stow ssh
stow tmux
stow vim
stow powerline
stow git
stow zsh
stow p10k
stow terminator
stow bin
#echo "if [ -f ~/.bash_custom ]; then . ~/.bash_custom; fi" >> ~/.bashrc
dconf load /com/gexperts/Tilix/ < tilix/tilix.dconf
wget -O - https://raw.githubusercontent.com/laurent22/joplin/master/Joplin_install_and_update.sh | bash
