function d
    set -l root (git rev-parse --show-toplevel)
    $root/ops/deploy $argv
end
