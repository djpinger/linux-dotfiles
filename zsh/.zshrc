eval "$(/opt/homebrew/bin/brew shellenv)"
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
#if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
#fi

#if [ -z "$TMUX" ] # When zsh is started attach to current tmux session or create a new one
#then
#    tmux attach -t TMUX || tmux new -s TMUX
#fi

export EDITOR="vim"
alias vi="vim"

autoload -U compinit && compinit # reload completions for zsh-completions

# Colorize autosuggest
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=5'

# This speeds up pasting w/ autosuggest
# https://github.com/zsh-users/zsh-autosuggestions/issues/238
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

# Load brew
[[ ! -f /home/linuxbrew/.linuxbrew/bin/brew ]] || eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
[[ ! -f /opt/homebrew/bin/brew ]] || eval "$(/opt/homebrew/bin/brew shellenv)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme ]] || source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme ]] || source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f /home/linuxbrew/.linuxbrew/opt/powerlevel10k/powerlevel10k.zsh-theme ]] || source /home/linuxbrew/.linuxbrew/opt/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme ]] || source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

source ~/.zsh_custom

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#export AWS_ACCESS_KEY_ID=$(aws configure get default.aws_access_key_id)
#export AWS_SECRET_ACCESS_KEY=$(aws configure get default.aws_secret_access_key)
