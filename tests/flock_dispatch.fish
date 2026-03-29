@test "flock with no args prints usage"
    set output (flock 2>&1)
    echo $output | string match -q "*Usage: flock*"
    @status 0
end

@test "flock with unknown subcommand returns error"
    flock unknowncmd 2>/dev/null
    @status 1
end

@test "flock unknown subcommand prints error message"
    set output (flock unknowncmd 2>&1)
    echo $output | string match -q "*unknown subcommand*"
    @status 0
end
