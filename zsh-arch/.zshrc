autoload -Uz compinit
compinit
# Use powerline
USE_POWERLINE="true"
# Source manjaro-zsh-configuration
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
  source /usr/share/zsh/manjaro-zsh-config
fi
# Use manjaro zsh prompt
if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
  source /usr/share/zsh/manjaro-zsh-prompt
fi

if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
  source /etc/profile.d/vte.sh
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

typeset -g POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND='kubectl|helm|kubens|kubectx|oc|istioctl|kogito'
source ~/powerlevel10k/powerlevel10k.zsh-theme
source ~/.zsh_custom
source /usr/share/nvm/init-nvm.sh
source /usr/share/nvm/init-nvm.sh
source /usr/share/nvm/init-nvm.sh
source /usr/share/nvm/init-nvm.sh
source /usr/share/nvm/init-nvm.sh
source /usr/share/nvm/init-nvm.sh
source /usr/share/nvm/init-nvm.sh
source /usr/share/nvm/init-nvm.sh
source /usr/share/nvm/init-nvm.sh
source /usr/share/nvm/init-nvm.sh
source /usr/share/nvm/init-nvm.sh
source /usr/share/nvm/init-nvm.sh
source /usr/share/nvm/init-nvm.sh
source /usr/share/nvm/init-nvm.sh
source /usr/share/nvm/init-nvm.sh
source /usr/share/nvm/init-nvm.sh
source /usr/share/nvm/init-nvm.sh
source /usr/share/nvm/init-nvm.sh
source /usr/share/nvm/init-nvm.sh
source /usr/share/nvm/init-nvm.sh
source /usr/share/nvm/init-nvm.sh
source /usr/share/nvm/init-nvm.sh
