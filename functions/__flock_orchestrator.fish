function __flock_orchestrator --description "Launch Claude Code orchestrator in the configured orchestrator repo"
    set -l orch_dir $FLOCK_ORCHESTRATOR_DIR

    if not test -d "$orch_dir/.git"
        echo "Error: orchestrator repo not found at $orch_dir" >&2
        echo "Set \$FLOCK_ORCHESTRATOR_DIR to override (default: ~/Development/dalp)" >&2
        return 1
    end

    if test -n "$ZELLIJ"
        zellij action rename-tab "Orchestrator" 2>/dev/null
    end

    cd $orch_dir
    echo "Orchestrator tab ready at $orch_dir"
end
