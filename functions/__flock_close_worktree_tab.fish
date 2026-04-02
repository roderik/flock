function __flock_close_worktree_tab --description "Close the Zellij tab for a worktree branch (best-effort by tab name)"
    set -l branch $argv[1]
    set -l skip_tab_id $argv[2]  # don't close this tab (the caller's tab)
    set -l return_tab_name $argv[3]  # tab name to return to after closing

    test -z "$ZELLIJ"; and return 1
    test -z "$branch"; and return 1

    # Tab names vary by creation method:
    #   branch:  short name (prefix stripped, 20 chars)
    #   linear:  ticket ID (e.g. PAP-123)
    #   PR:      #N (can't derive from branch alone)
    set -l short_name (string replace -r '^[^/]+/' '' -- $branch | string sub -l 20)
    set -l ticket_name (string match -r '^[A-Za-z]+-\d+' -- $branch)

    for try_name in "$short_name" "$ticket_name" "$branch"
        test -z "$try_name"; and continue
        zellij action go-to-tab-name "$try_name" 2>/dev/null; or continue
        set -l tid (zellij action current-tab-info --json 2>/dev/null | jq -r '.tab_id // empty' 2>/dev/null)
        if test -n "$tid"; and test "$tid" != "$skip_tab_id"
            zellij action close-tab-by-id $tid 2>/dev/null
            # Return to the caller's tab
            if test -n "$return_tab_name"
                zellij action go-to-tab-name "$return_tab_name" 2>/dev/null
            end
            return 0
        end
    end
    return 1
end
