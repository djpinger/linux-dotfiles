# CachyOS's default config.fish (fastfetch greeting, !!/!$ bindings, `done`
# notification plugin, its own alias set) — keep it loading first so our
# exports/aliases below layer on top and win on overlap (ls/la/ll, grep, etc.)
if test -f /usr/share/cachyos-fish-config/cachyos-config.fish
    source /usr/share/cachyos-fish-config/cachyos-config.fish
end

if status is-interactive
    stty -ixon
end

set -e AWS_PROFILE

if test -d /usr/local/Cellar
    set -gx PATH $PATH /usr/local/Cellar
end
set -gx PATH /var/lib/snapd/snap/bin /usr/local/bin /usr/local/sbin $PATH

eval (ssh-agent -c) >/dev/null
test -f ~/.ssh/id_ed25519_work; and ssh-add ~/.ssh/id_ed25519_work
test -f ~/.ssh/id_ed25519_personal; and ssh-add ~/.ssh/id_ed25519_personal

# fish has its own fzf key-binding mechanism instead of sourcing completion.zsh/key-bindings.zsh
if type -q fzf
    fzf --fish | source
end

if test -x /usr/bin/dircolors
    # dircolors -b emits POSIX shell syntax (LS_COLORS='...'; export LS_COLORS),
    # which fish's `eval` can't parse — extract just the value instead.
    if test -r ~/.dircolors
        set -gx LS_COLORS (dircolors -b ~/.dircolors | sed -E "s/^LS_COLORS='(.*)';.*/\1/")
    else
        set -gx LS_COLORS (dircolors -b | sed -E "s/^LS_COLORS='(.*)';.*/\1/")
    end
    alias grep 'grep --color=auto'
    alias fgrep 'fgrep --color=auto'
    alias egrep 'egrep --color=auto'
end

test -f /usr/local/etc/profile.d/autojump.sh; and source /usr/local/etc/profile.d/autojump.sh
if type -q kubectl
    kubectl completion fish | source
end

# NOTE: fubectl.source (~/fubectl.source, stowed from zsh/) is a third-party
# bash/zsh script (functions, ${VAR:-default}, etc.) and is NOT sourced here —
# it won't parse under fish. It stays zsh-only unless someone ports it separately.

test -f /opt/homebrew/opt/asdf/libexec/asdf.fish; and source /opt/homebrew/opt/asdf/libexec/asdf.fish
test -f /opt/asdf-vm/asdf.fish; and source /opt/asdf-vm/asdf.fish
test -f /usr/local/opt/asdf/libexec/asdf.fish; and source /usr/local/opt/asdf/libexec/asdf.fish
test -f /home/linuxbrew/.linuxbrew/opt/asdf/libexec/asdf.fish; and source /home/linuxbrew/.linuxbrew/opt/asdf/libexec/asdf.fish
# NOTE: ~/.asdf/plugins/java/set-java-home.zsh has no fish-native equivalent
# shipped by the asdf-java plugin; JAVA_HOME won't get auto-set under fish.

set -gx PATH $PATH $HOME/.asdf
set -gx PATH /home/linuxbrew/.linuxbrew/opt/openssl@3/bin $PATH
set -gx PKG_CONFIG_PATH /home/linuxbrew/.linuxbrew/opt/openssl@3/lib/pkgconfig

# gcloud stuff (gcloud does not ship a fish completion script)
set -gx PATH $PATH /opt/homebrew/share/google-cloud-sdk/bin

if test -n "$SSH_CLIENT" -o -n "$SSH_TTY"
    set -gx STARSHIP_CONFIG "$HOME/.config/starship-ssh.toml"
end
set -gx EDITOR vim
set -gx BLOCKSIZE 1k
set -gx CLICOLOR 1
set -gx LSCOLORS ExFxBxDxCxegedabagacad
set -gx GOPATH $HOME/go
set -gx PATH $PATH $GOPATH/bin
set -gx GOROOT (find ~/.asdf/installs/golang -mindepth 2 -maxdepth 2 -type d -name go 2>/dev/null | tail -1)
set -gx COLORTERM truecolor
set -gx TERM xterm-256color
set -gx USE_GKE_GCLOUD_AUTH_PLUGIN True
set -gx PODMAN_COMPOSE_WARNING_LOGS false

# AWS
set -gx AWS_VAULT_PROMPT terminal
set -gx AWS_SESSION_TOKEN_TTL 12h
set -gx AWS_CHAINED_SESSION_TOKEN_TTL 12h
set -gx AWS_ASSUME_ROLE_TTL 12h
set -gx AWS_FEDERATION_TOKEN_TTL 12h

set -gx PATH ~/.local/bin ~/bin $PATH
set -gx GITHUB_TOKEN (gh auth token)

# mac GNU stuff
set -gx PATH /opt/homebrew/opt/make/libexec/gnubin $PATH
set -gx PATH $PATH $HOME/.rd/bin

# bun
test -s "$HOME/.bun/_bun"; and source "$HOME/.bun/_bun"
set -gx BUN_INSTALL "$HOME/.bun"
set -gx PATH $BUN_INSTALL/bin $PATH

# zoxide
if type -q zoxide
    zoxide init fish | source
end

# npm
set -gx PATH ~/.npm-global/bin $PATH

# lmstudio
if test -d "$HOME/.lmstudio/bin"
    set -gx PATH $PATH $HOME/.lmstudio/bin
end

# obsidian CLI
set -gx PATH $PATH /usr/local/bin/obsidian

# opencode
set -gx PATH ~/.opencode/bin $PATH

# Google Cloud SDK python
# Homebrew python upgrades delete the interpreter gcloud hardcodes, which breaks
# both gcloud and gke-gcloud-auth-plugin. Pin CLOUDSDK_PYTHON to the first
# python3 that exists (macOS Homebrew arm/intel, then Linux). Only set if found.
for _py in /opt/homebrew/bin/python3 /usr/local/bin/python3 /usr/bin/python3
    if test -x $_py
        set -gx CLOUDSDK_PYTHON $_py
        break
    end
end
set -e _py

# Ring the terminal bell after any foreground command (shell command, ssh
# session, etc.) that runs longer than $__bell_threshold_ms milliseconds.
# Ghostty's bell-features (attention,system) turns that into a dash badge +
# desktop notification, so backgrounded/inactive panes surface when they finish.
# A few full-screen interactive commands are excluded since exiting them
# isn't "done working" (ssh is intentionally NOT excluded). Defined here
# (not in functions/) so the fish_postexec handler registers on every startup
# instead of waiting on lazy autoload.
set -g __bell_threshold_ms 10000
set -g __bell_exclude vim nvim nano man less more top htop

function __bell_postexec --on-event fish_postexec
    test -n "$CMD_DURATION"; or return
    test $CMD_DURATION -ge $__bell_threshold_ms; or return
    set -l first_word (string split -m1 ' ' -- $argv[1])[1]
    set -l cmd_name (path basename -- $first_word)
    if not contains -- $cmd_name $__bell_exclude
        printf '\a'
    end
end

source ~/.config/fish/aliases.fish
