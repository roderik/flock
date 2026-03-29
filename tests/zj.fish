@test "zj inside a zellij session prints already-inside message"
    set -x ZELLIJ "0"
    set output (zj 2>&1)
    set -e ZELLIJ
    echo $output | string match -q "*Already inside*"
    @status 0
end

@test "zj inside zellij returns 0"
    set -x ZELLIJ "0"
    zj 2>/dev/null
    set exit_code $status
    set -e ZELLIJ
    test $exit_code -eq 0
    @status 0
end
