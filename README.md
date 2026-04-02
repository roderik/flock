# flock

![flock hero](assets/hero.jpg)

A [fisher](https://github.com/jorgebucaran/fisher) plugin for git worktree management — create, switch, and clean up worktrees with an auto-configured multi-pane workspace (Zellij or cmux).

Each `flock new` opens a new Zellij tab with five panes: your AI coding assistant (Claude or Codex) in the main pane, plus a stacked sidebar with a terminal, clickable Zed deep link, lazygit, and k9s — all scoped to the worktree directory.

## Install

```fish
fisher install roderik/flock
```

## Dependencies

**Required:** `git`, `gh`, `fzf`, `jq`, [worktrunk](https://github.com/nicholasgasior/worktrunk) (`wt` binary)

**Optional:**
- `zellij` or `cmux` — multi-pane workspace support (degrades to bare terminal without)
- `lazygit` — git pane in workspace
- `k9s` — Kubernetes monitor pane in workspace
- `linear` CLI — Linear ticket integration
- `claude` or `codex` — AI assistant launched in main pane
- `btop` — system monitor in dashboard layout

## Usage

```fish
flock new [branch|PR|ticket]   # Create or open a worktree
flock delete                   # Delete a worktree via fzf picker
flock delete --all             # Delete all worktrees
flock tab-setup                # Set up workspace in the current dir
```

### flock new

Without arguments, opens an fzf picker showing existing worktrees and open GitHub PRs.

```fish
flock new                      # fzf picker: worktrees + open PRs
flock new my-feature           # create worktree on branch my-feature
flock new 42                   # check out PR #42
flock new https://github.com/org/repo/pull/42
flock new PAP-123              # create worktree from Linear ticket
flock new https://linear.app/org/issue/PAP-123/my-ticket
flock new -x my-feature        # same, but launch codex instead of claude
```

### flock delete

Opens an fzf picker listing all worktrees (current branch preselected). Removes the worktree, its local branch, closes the worktree's Zellij tab (stopping all running processes), and prunes remote refs.

```fish
flock delete                   # pick one worktree to delete
flock delete --all             # delete all worktrees and close all tabs
```

### flock tab-setup

Opens a new workspace tab (Zellij or cmux) scoped to the current directory with the AI assistant auto-launched in the main pane.

```fish
flock tab-setup
flock tab-setup -x             # launch codex instead of claude
```

## Zellij session helpers

```fish
zj [session]                   # start or attach to a local zellij session
zjr [host]                     # start or attach to a remote zellij session
```

Both use the `flock-dashboard` layout for new sessions (btop + terminal). `zjr` defaults to `$FLOCK_REMOTE_HOST`.

## Abbreviations

| Subcommand           | `f*`    | `wt*` |
|----------------------|---------|-------|
| `flock new`          | `fn`    | `wtn` |
| `flock delete`       | `fdel`  | `wtd` |
| `flock delete --all` | `fdela` |       |
| `flock tab-setup`    | `fs`    | `wts` |

`wt*` abbreviations are retained for backward compatibility.

## Configuration

| Variable             | Default    | Purpose                             |
|----------------------|------------|-------------------------------------|
| `$FLOCK_REMOTE_HOST` | `daystrom` | Remote host used by `zjr`           |

```fish
set -gx FLOCK_REMOTE_HOST myserver
```

## Zellij layouts

Two layouts are included and auto-installed to `~/.config/zellij/layouts/` on shell start:

### Worktree tab (`flock.kdl`)

Used by `flock new` and `flock tab-setup` for each worktree tab:

| Area | Pane | Description |
|------|------|-------------|
| Left 70% (focused) | **Main** | AI assistant (Claude or Codex) |
| Right 30% (stacked) | **Zed** | Clickable `zed://` deep link to open worktree in Zed |
| | **Terminal** | Plain shell |
| | **Git** | `lazygit` |
| | **K9s** | `k9s` Kubernetes monitor |

### Dashboard (`flock-dashboard.kdl`)

Used by `zj` / `zjr` for new Zellij sessions:

- **Left 50%** — `btop` system monitor
- **Right 50%** — Terminal (focused)

## License

MIT
