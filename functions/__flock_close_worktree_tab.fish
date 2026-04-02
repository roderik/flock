function __flock_close_worktree_tab --description "Close the Zellij tab for a worktree branch (best-effort by tab name)"
    set -l branch $argv[1]
    set -l skip_tab_id $argv[2] # don't close this tab (the caller's tab)

    test -z "$ZELLIJ"; and return 1
    test -z "$branch"; and return 1

    # Tab names are set by __flock_tab_setup: short branch (prefix stripped, 20 chars)
    set -l short_name (string replace -r '^[^/]+/' '' -- $branch | string sub -l 20)

    # Try to navigate to the tab and close it
    for try_name in "$short_name" "$branch"
        zellij action go-to-tab-name "$try_name" 2>/dev/null; or continue
        set -l tid (zellij action current-tab-info --json 2>/dev/null | jq -r '.tab_id // empty' 2>/dev/null)
        # Only close if we actually switched to a different tab
        if test -n "$tid"; and test "$tid" != "$skip_tab_id"
            zellij action close-tab-by-id $tid 2>/dev/null
            return 0
        end
    end
    return 1
end
