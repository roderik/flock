function flock --description "Git worktree manager with integrated workspace setup"
    set -l subcommand $argv[1]
    set -e argv[1]

    switch $subcommand
        case new
            __flock_new $argv
        case delete del rm
            __flock_delete $argv
        case orchestrator orch
            __flock_orchestrator $argv
        case tab-setup ts
            __flock_tab_setup $argv
        case ''
            echo "Usage: flock <subcommand> [args]"
            echo ""
            echo "Subcommands:"
            echo "  new [branch|#PR|TICKET]   Create or open a worktree"
            echo "  delete                    Delete a worktree via fzf picker"
            echo "  orchestrator              Open the orchestrator tab"
            echo "  tab-setup                 Set up a 3-pane workspace in the current dir"
        case '*'
            echo "flock: unknown subcommand '$subcommand'" >&2
            return 1
    end
end
