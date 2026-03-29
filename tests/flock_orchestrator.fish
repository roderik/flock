@test "flock orchestrator fails when FLOCK_ORCHESTRATOR_DIR does not exist"
    set -x FLOCK_ORCHESTRATOR_DIR "/tmp/nonexistent-orch-dir-$$"
    __flock_orchestrator 2>/dev/null
    set exit_code $status
    set -e FLOCK_ORCHESTRATOR_DIR
    test $exit_code -ne 0
    @status 0
end

@test "flock orchestrator prints error for missing dir"
    set -x FLOCK_ORCHESTRATOR_DIR "/tmp/nonexistent-orch-dir-$$"
    set output (__flock_orchestrator 2>&1)
    set -e FLOCK_ORCHESTRATOR_DIR
    echo $output | string match -q "*not found*"
    @status 0
end
