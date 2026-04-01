function __flock_delete --description "Delete a worktree via fzf picker (current worktree preselected)"
    set -l repo_root (__flock_repo_root)
    or return
    test -z "$repo_root"; and return

    # Capture the originating tab ID so we close the right tab even if focus moves
    set -l zellij_tab_id
    if test -n "$ZELLIJ"
        set zellij_tab_id (zellij action list-panes --json 2>/dev/null | jq -r '.[] | select(.is_focused) | .tab_id // empty' 2>/dev/null)
    end

    # ── Delete all mode ──────────────────────────────────────────────────
    if test "$argv[1]" = --all -o "$argv[1]" = -a
        set -l worktrees (git -C $repo_root worktree list | tail -n +2)
        if test -z "$worktrees"
            echo "No worktrees to delete."
            return 0
        end

        echo "Will delete "(count $worktrees)" worktree(s):"
        for line in $worktrees
            echo "  $line"
        end
        read -P "Confirm? [y/N] " -l confirm
        test "$confirm" = y -o "$confirm" = Y; or return

        cd $repo_root

        for line in $worktrees
            set -l wt_path (string match -r '^\S+' -- $line)
            set -l branch (string match -r '\[(.+)\]' -- $line)[2]
            echo "Removing: $branch ($wt_path)"
            git -C $repo_root worktree remove --force "$wt_path" 2>/dev/null
            git -C $repo_root branch -D $branch 2>/dev/null
        end
        git -C $repo_root remote prune origin 2>/dev/null

        if test -n "$ZELLIJ"
            if test -n "$zellij_tab_id"
                zellij action close-tab --tab-id $zellij_tab_id 2>/dev/null
            else
                zellij action close-tab 2>/dev/null
            end
        else if set -q CMUX_WORKSPACE_ID
            cmux close-workspace 2>/dev/null
        end
        return 0
    end

    # ── Single delete via fzf picker ─────────────────────────────────────
    set -l current_branch (git branch --show-current 2>/dev/null)

    set -l current_line
    set -l other_lines
    for line in (git -C $repo_root worktree list | tail -n +2)
        set -l wt_branch (string match -r '\[(.+)\]' -- $line)[2]
        if test "$wt_branch" = "$current_branch"
            set current_line "$line (current)"
        else
            set -a other_lines "$line"
        end
    end

    set -l target ({
        test -n "$current_line"; and echo $current_line
        for line in $other_lines; echo $line; end
    } | fzf --height=40% --reverse --header "Delete which worktree?" \
        | string replace ' (current)' '' | string match -r '^\S+')
    test -z "$target"; and return

    set -l branch (git -C $repo_root worktree list | string match "$target *" | string match -r '\[(.+)\]')[2]
    set -l is_current false

    if test "$PWD" = "$target"; or string match -q "$target/*" $PWD
        set is_current true
        cd $repo_root
    end

    echo "Removing worktree: $branch ($target)"
    git -C $repo_root worktree remove --force "$target" 2>/dev/null
    git -C $repo_root remote prune origin 2>/dev/null
    git -C $repo_root branch -D $branch 2>/dev/null

    if test "$is_current" = true
        if test -n "$ZELLIJ"
            if test -n "$zellij_tab_id"
                zellij action close-tab --tab-id $zellij_tab_id 2>/dev/null
            else
                zellij action close-tab 2>/dev/null
            end
        else if set -q CMUX_WORKSPACE_ID
            cmux close-workspace 2>/dev/null
        end
    end
end
