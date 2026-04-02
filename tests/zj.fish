@test "zj inside a zellij session prints already-inside message"
    set -x ZELLIJ "0"
    set output (zj 2>&1)
    set -e ZELLIJ
    echo $output | string match -q "*Already inside*"
    @status 0
end

@test "zj inside zellij returns 0"
    set -x ZELLIJ "0"
    zj 2>/dev/null
    set exit_code $status
    set -e ZELLIJ
    test $exit_code -eq 0
    @status 0
end

@test "zj attaches to existing session by name"
    function zellij
        if test "$argv[1]" = list-sessions
            echo "mysession [Created 1h ago]"
            return 0
        end
        echo $argv >/tmp/_zj_test_cmd
        return 0
    end

    zj mysession >/dev/null 2>&1

    set -l cmd (cat /tmp/_zj_test_cmd)
    rm -f /tmp/_zj_test_cmd
    functions -e zellij

    string match -q "attach -- mysession" -- $cmd
    @status 0
end

@test "zj creates new session with dashboard layout when session does not exist"
    function zellij
        if test "$argv[1]" = list-sessions
            echo "othersession [Created 1h ago]"
            return 0
        end
        echo $argv >/tmp/_zj_test_cmd
        return 0
    end

    zj newsession >/dev/null 2>&1

    set -l cmd (cat /tmp/_zj_test_cmd)
    rm -f /tmp/_zj_test_cmd
    functions -e zellij

    string match -q "*--layout flock-dashboard --session newsession*" -- $cmd
    @status 0
end

@test "zj without args uses dashboard layout"
    function zellij
        if test "$argv[1]" = list-sessions
            return 1
        end
        echo $argv >/tmp/_zj_test_cmd
        return 0
    end

    zj >/dev/null 2>&1

    set -l cmd (cat /tmp/_zj_test_cmd)
    rm -f /tmp/_zj_test_cmd
    functions -e zellij

    string match -q "*--layout flock-dashboard*" -- $cmd
    @status 0
end
