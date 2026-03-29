@test "zjr without host and without FLOCK_REMOTE_HOST returns error"
    set -e FLOCK_REMOTE_HOST
    zjr 2>/dev/null
    @status 1
end

@test "zjr without host prints error message"
    set -e FLOCK_REMOTE_HOST
    set output (zjr 2>&1)
    echo $output | string match -q "*no remote host*"
    @status 0
end
