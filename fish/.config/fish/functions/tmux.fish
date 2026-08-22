# Bare `tmux` (no args) attaches to the most recently used session instead of
# always starting a new unnamed one. Any args (attach, new -s foo, ls, etc.)
# pass through untouched.
function tmux
    if test (count $argv) -eq 0
        command tmux attach 2>/dev/null; or command tmux new-session
    else
        command tmux $argv
    end
end
