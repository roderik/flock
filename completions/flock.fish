# Tab completions for flock

set -l subcommands new delete tab-setup

complete -c flock -f -n "not __fish_seen_subcommand_from $subcommands" -a new          -d "Create or open a worktree"
complete -c flock -f -n "not __fish_seen_subcommand_from $subcommands" -a delete        -d "Delete a worktree via fzf picker"
complete -c flock -f -n "not __fish_seen_subcommand_from $subcommands" -a tab-setup     -d "Set up a 3-pane workspace"

# flock new options
complete -c flock -n "__fish_seen_subcommand_from new" -s x -d "Use codex instead of Claude"
