function gcb
    if test -z "$argv[1]"
        echo "Please enter branch name to create"
        return 1
    end
    git checkout -b $argv[1]
    git push -u origin $argv[1]
end
