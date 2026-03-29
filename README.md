# flock

A [fisher](https://github.com/jorgebucaran/fisher) plugin for git worktree management with integrated workspace setup.

## Install

```fish
fisher install roderik/flock
```

## Usage

```fish
flock new [branch|PR|ticket]   # Create or open a worktree
flock delete                   # Delete a worktree via fzf picker
flock orchestrator             # Open the orchestrator tab
```

### Abbreviations

| Command           | Short (`f*`) | Compat (`wt*`) |
|-------------------|-------------|----------------|
| `flock new`       | `fn`        | `wtn`          |
| `flock delete`    | `fd`        | `wtd`          |
| `flock orchestrator` | `fo`    | `wto`          |

## Configuration

| Variable                | Default            | Purpose                        |
|-------------------------|--------------------|--------------------------------|
| `$FLOCK_ORCHESTRATOR_DIR` | `~/Development/dalp` | Orchestrator repo path       |
| `$FLOCK_REMOTE_HOST`    | `daystrom`         | Remote host for `zjr`          |

## Dependencies

- [worktrunk](https://github.com/nicholasgasior/worktrunk) (`wt` binary)
- `zellij` or `cmux` (optional, degrades gracefully)
- `git`, `gh`, `fzf`, `lazygit`
- `linear` CLI (optional, for Linear ticket integration)

## License

MIT
