# KUBERNETES
alias kubectl 'kubecolor'
alias k 'kubectl'
alias kx 'kubectx'
alias klogs 'k logs'
alias kpods 'k get pods'
alias kservices 'k get services --sort-by=.metadata.name'
alias k9 'k9s -n default'
alias krestart 'k rollout restart deployment'
alias kevents 'kubectl events'
alias kwarn 'kevents --types=Warning'

# GENERAL
alias services 'systemctl list-units --type=service'
alias slogs 'journalctl -u'
alias qfind 'find . -name '                                     # qfind:    Quickly search for file
alias myip 'echo (curl http://ipecho.net/plain 2>/dev/null)'    # myip:         Public facing IP Address
alias netCons 'lsof -i'                                         # netCons:      Show all open TCP/IP sockets
alias flushDNS 'dscacheutil -flushcache'                        # flushDNS:     Flush out the DNS Cache (macOS only)
alias lsock 'sudo /usr/sbin/lsof -i -P'                         # lsock:        Display open sockets
alias lsockU 'sudo /usr/sbin/lsof -nP | grep UDP'                # lsockU:       Display only open UDP sockets
alias lsockT 'sudo /usr/sbin/lsof -nP | grep TCP'                # lsockT:       Display only open TCP sockets
alias ipInfo0 'ipconfig getpacket en0'                           # ipInfo0:      Get info on connections for en0 (macOS only)
alias ipInfo1 'ipconfig getpacket en1'                           # ipInfo1:      Get info on connections for en1 (macOS only)
alias openPorts 'sudo lsof -i | grep LISTEN'                     # openPorts:    All listening connections
alias showBlocked 'sudo ipfw list'                               # showBlocked:  All ipfw rules inc/ blocked IPs (macOS only)

alias ll 'ls -alF'
alias la 'ls -hA'
alias l 'ls -CF'
alias vi 'vim'
alias nomore 'find ./ -iname .DS_Store -delete'
alias ls 'eza'
alias av 'aws-vault'
alias ave 'aws-vault exec'
alias awsid 'aws sts get-caller-identity'
alias dl 'dw'
alias tmc 'tmux -CC'
alias tma 'tmux -CC attach'
alias nnn 'nnn -e'

# GIT
alias gc 'git clone'
alias gprune 'git gc --prune=now'
alias gp 'git pull'
alias gitgraph 'git log --graph --abbrev-commit --pretty=oneline origin..main'
alias gweb 'gh repo view -b (git branch --show-current)/(git rev-parse --show-prefix) -w'
alias gclean 'git clean -fd'
alias gpr 'gh pr create --web'
alias gd 'ydiff -s -w0 --wrap'
alias gpsm 'git submodule update --recursive'

# DOCKER
alias dcup 'docker compose up -d'
alias dcstop 'docker compose stop'
alias dcdestroy 'docker compose stop && docker compose rm -f'
alias dcps 'docker compose ps'
alias dclogs 'docker compose logs -f'
alias dcbuild 'docker compose build'
alias dcvi 'vi docker compose.yml'
alias dcpull 'docker compose pull'
alias dc 'docker compose'

alias ptop 'bpytop'
alias pbcopy 'xclip -selection clipboard'
alias pbpaste 'xclip -selection clipboard -o'
alias awsorg "aws organizations list-accounts --query 'Accounts[].[Name,Status]' --output text"

alias parui 'paru -Syu --noconfirm'
alias yayi 'yay -Syu --noconfirm'
alias yayu 'yay -Rsc'

alias g 'gvim --remote-tab-silent'

alias glogin 'gcloud auth application-default login'
alias gcplist 'gcloud projects list |  grep -v "^sys"'
alias gcpproject 'gcloud config set project'
alias gcpid 'gcloud config get-value project'
alias gcpauth 'gcloud auth login --update-adc'

# b/d: fish forbids a command substitution in command position, so these are
# functions (see functions/b.fish, functions/d.fish) instead of aliases here.

alias tablet 'scrcpy --video-codec=h265 --max-fps=60 --no-audio'

# attach --create: resurrect "main" if it exists, else create it; --force-run-commands
# re-runs serialized commands without the "Press ENTER" banner
alias zm 'zellij attach --create main --force-run-commands'
alias za 'zellij attach --force-run-commands'
alias zf 'zellij -l strider'
alias zd 'zellij delete-all-sessions'
alias zk9s 'zellij -s k9s --layout $HOME/.config/zellij/k9s.kdl'

alias pythond 'docker run -it --name python -v .:/usr/src/app -w /usr/src/app python:3 /bin/bash'

# PODMAN - use docker commands with podman (only if podman is installed)
if command -v podman >/dev/null 2>&1
    alias docker 'podman'
    alias docker-compose 'podman-compose'
end

# NOTE: zsh-only suffix aliases (`alias -s json=jless`, `... yaml=...`, `... md=...`)
# and global aliases (`alias -g NE='2>/dev/null'`, DN, NUL, JQ, C) have no fish
# equivalent and are intentionally dropped. Fish's closest analog is `abbr`, but
# that expands inline at the prompt rather than matching by file suffix / mid-command
# — worth a separate pass if you want them, not a 1:1 port.
