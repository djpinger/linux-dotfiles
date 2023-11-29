# MAIN
#

export EDITOR="vim"
alias vi="vim"

# Load brew
[[ ! -f /home/linuxbrew/.linuxbrew/bin/brew ]] || eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
[[ ! -f /opt/homebrew/bin/brew ]] || eval "$(/opt/homebrew/bin/brew shellenv)"

eval "$(starship init bash)"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

source ~/.exports
source ~/.functions
source ~/.aliases
