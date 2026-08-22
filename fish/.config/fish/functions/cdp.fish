function cdp
    set -l base $WORK_CODE_DIR
    if test -z "$base"
        set base ~/g/work
    end
    cd $base/$argv[1]
end
