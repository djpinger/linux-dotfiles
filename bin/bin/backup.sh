rsync -a --delete --exclude 'linux-dotfiles' --exclude '.var' --exclude '.local' --exclude '.pyenv' --exclude '.cpan' --exclude '.kube' --exclude '.aws-sam' --exclude '.bundle' --exclude '.cache' --exclude '.config' --exclude 'snap' --exclude 'Downloads' --exclude '.rbenv' --exclude '.vscode' --exclude '.asdf' --exclude '.npm' --exclude 'go' --exclude 'rpi' --exclude '.cargo' --exclude '.nvm' --exclude '.mozilla' --exclude '.emacs.d' $HOME /mnt/external/rsync/picnic
