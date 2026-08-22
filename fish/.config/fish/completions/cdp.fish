function __cdp_complete
    set -l base $WORK_CODE_DIR
    if test -z "$base"
        set base ~/g/work
    end
    for d in $base/*/
        basename $d
    end
end

complete -c cdp -f -a "(__cdp_complete)"
