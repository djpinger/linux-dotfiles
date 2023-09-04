DIR="/mnt/backup/rsync/picnic"
mkdir -p $DIR
rsync --progress -a --delete --exclude 'g' --exclude 'linux-dotfiles' --exclude '.var' --exclude '.local' --exclude '.pyenv' --exclude '.cpan' --exclude '.kube' --exclude '.aws-sam' --exclude '.bundle' --exclude '.cache' --exclude '.config' --exclude 'snap' --exclude 'Downloads' --exclude '.rbenv' --exclude '.vscode' --exclude '.asdf' --exclude '.npm' --exclude 'go' --exclude 'rpi' --exclude '.cargo' --exclude '.nvm' --exclude '.mozilla' --exclude '.emacs.d' --exclude '.gradle' --exclude 'node_modules' --exclude 'zoom' $HOME $DIR
