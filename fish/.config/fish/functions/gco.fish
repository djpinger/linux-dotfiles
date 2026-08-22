function gco
    if test -z "$argv[1]"
        echo "Please specify a branch name"
        return 1
    end

    git fetch; or return 1

    if git show-ref --verify --quiet refs/heads/$argv[1]
        git checkout $argv[1]; or return 1
        git pull
    else
        git checkout -b $argv[1] origin/$argv[1] 2>/dev/null; or git checkout $argv[1]
    end
end
