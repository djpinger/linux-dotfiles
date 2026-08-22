function awsrole
    set -e AWS_VAULT
    for line in (aws-vault exec $argv[1] -- env | grep '^AWS_')
        set -l kv (string split -m1 '=' -- $line)
        set -gx $kv[1] $kv[2]
    end
    set -gx AWS_PROFILE $argv[1]
    set -gx DEFAULT_AWS_PROFILE $argv[1]
end
