@test "__flock_close_worktree_tab closes tab matching short branch name"
    set -x ZELLIJ 1

    function zellij
        if test "$argv[2]" = go-to-tab-name
            echo $argv[3] >>/tmp/_flock_test_tab_queries
            return 0
        end
        if test "$argv[2]" = current-tab-info
            echo '{"tab_id": 99, "name": "my-feature"}'
            return 0
        end
        if test "$argv[2]" = close-tab-by-id
            echo $argv[3] >/tmp/_flock_test_closed_id
            return 0
        end
    end

    rm -f /tmp/_flock_test_tab_queries /tmp/_flock_test_closed_id

    __flock_close_worktree_tab "roderik/my-feature" "42" "Dashboard"

    set -l closed_id (cat /tmp/_flock_test_closed_id 2>/dev/null)
    rm -f /tmp/_flock_test_tab_queries /tmp/_flock_test_closed_id
    functions -e zellij
    set -e ZELLIJ

    test "$closed_id" = 99
    @status 0
end

@test "__flock_close_worktree_tab skips caller tab ID"
    set -x ZELLIJ 1

    function zellij
        if test "$argv[2]" = go-to-tab-name
            return 0
        end
        if test "$argv[2]" = current-tab-info
            echo '{"tab_id": 42, "name": "my-feature"}'
            return 0
        end
        if test "$argv[2]" = close-tab-by-id
            echo $argv[3] >/tmp/_flock_test_closed_id
            return 0
        end
    end

    rm -f /tmp/_flock_test_closed_id

    __flock_close_worktree_tab "my-feature" "42" "Dashboard"
    set -l result $status

    set -l closed_id (cat /tmp/_flock_test_closed_id 2>/dev/null)
    rm -f /tmp/_flock_test_closed_id
    functions -e zellij
    set -e ZELLIJ

    test $result -ne 0 -a -z "$closed_id"
    @status 0
end

@test "__flock_close_worktree_tab tries ticket ID from branch"
    set -x ZELLIJ 1

    function zellij
        if test "$argv[2]" = go-to-tab-name
            echo $argv[3] >>/tmp/_flock_test_tab_queries
            if test "$argv[3]" = PAP-123
                return 0
            end
            return 1
        end
        if test "$argv[2]" = current-tab-info
            echo '{"tab_id": 77, "name": "PAP-123"}'
            return 0
        end
        if test "$argv[2]" = close-tab-by-id
            echo $argv[3] >/tmp/_flock_test_closed_id
            return 0
        end
    end

    rm -f /tmp/_flock_test_tab_queries /tmp/_flock_test_closed_id

    __flock_close_worktree_tab "PAP-123-my-ticket-title" "42" ""

    set -l closed_id (cat /tmp/_flock_test_closed_id 2>/dev/null)
    set -l queries (cat /tmp/_flock_test_tab_queries 2>/dev/null)
    rm -f /tmp/_flock_test_tab_queries /tmp/_flock_test_closed_id
    functions -e zellij
    set -e ZELLIJ

    test "$closed_id" = 77
    @status 0
end
