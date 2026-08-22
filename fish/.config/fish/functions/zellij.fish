# Bare `zellij` (no args) auto-attaches to the "Main" session per config.kdl
# (session_name "Main" + attach_to_session true). That path can't pass
# --force-run-commands, so resurrected commands stall behind "Press ENTER to run".
# This wrapper replicates the auto-attach but forces serialized commands to re-run
# (tmux-resurrect/continuum-style). Any args (attach, subcommands, flags) pass through.
function zellij
    if test (count $argv) -eq 0
        command zellij attach --create Main --force-run-commands
    else
        command zellij $argv
    end
end
