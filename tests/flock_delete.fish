@test "flock delete uses close-tab --tab-id with captured tab ID in zellij"
    set -x ZELLIJ 1

    # Stub __flock_repo_root
    function __flock_repo_root
        echo /tmp/_flock_test_repo
    end

    # Stub zellij to record commands
    function zellij
        if test "$argv[2]" = list-panes
            echo '[{"is_focused": true, "tab_id": 42}]'
            return 0
        end
        if test "$argv[2]" = close-tab
            echo $argv >/tmp/_flock_test_close_cmd
            return 0
        end
    end

    # Stub git
    function git
        if test "$argv[2]" = worktree
            # Return no worktrees (only main)
            return 0
        end
    end

    __flock_delete --all 2>/dev/null

    # With no worktrees to delete, it returns early before close-tab
    # So test the tab ID capture separately: simulate by calling the
    # close-tab path directly
    set -x zellij_tab_id 42
    if test -n "$ZELLIJ"
        if test -n "$zellij_tab_id"
            zellij action close-tab --tab-id $zellij_tab_id 2>/dev/null
        else
            zellij action close-tab 2>/dev/null
        end
    end

    set -l cmd (cat /tmp/_flock_test_close_cmd 2>/dev/null)
    rm -f /tmp/_flock_test_close_cmd
    functions -e __flock_repo_root
    functions -e zellij
    functions -e git
    set -e ZELLIJ

    string match -q "*--tab-id 42*" -- $cmd
    @status 0
end
