function b
    set -l root (git rev-parse --show-toplevel)
    $root/ops/build $argv
end
