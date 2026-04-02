@test "zjr without host and without FLOCK_REMOTE_HOST returns error"
    set -e FLOCK_REMOTE_HOST
    zjr 2>/dev/null
    @status 1
end

@test "zjr without host prints error message"
    set -e FLOCK_REMOTE_HOST
    set output (zjr 2>&1)
    echo $output | string match -q "*no remote host*"
    @status 0
end

@test "zjr strips ANSI codes and CR from session names when attaching"
    set -x FLOCK_REMOTE_HOST testhost

    function ssh
        if string match -q "*list-sessions*" -- $argv
            printf '\e[32madventurous-tambourine\e[0m [Created 1h ago]\r\n'
            return 0
        end
        echo $argv >/tmp/_zjr_test_attach_cmd
        return 0
    end

    echo 1 | zjr >/dev/null 2>&1

    set -l cmd (cat /tmp/_zjr_test_attach_cmd)
    rm -f /tmp/_zjr_test_attach_cmd
    functions -e ssh

    string match -q "*zellij attach 'adventurous-tambourine'*" -- $cmd
    @status 0
end

@test "zjr new session uses dashboard layout with fallback"
    set -x FLOCK_REMOTE_HOST testhost

    function ssh
        if string match -q "*list-sessions*" -- $argv
            printf 'existing-session [Created 1h ago]\r\n'
            return 0
        end
        echo $argv >/tmp/_zjr_test_new_cmd
        return 0
    end

    echo n | zjr >/dev/null 2>&1

    set -l cmd (cat /tmp/_zjr_test_new_cmd)
    rm -f /tmp/_zjr_test_new_cmd
    functions -e ssh

    string match -q "*--layout flock-dashboard*" -- $cmd
    @status 0
end

@test "zjr with no existing sessions uses dashboard layout with fallback"
    set -x FLOCK_REMOTE_HOST testhost

    function ssh
        if string match -q "*list-sessions*" -- $argv
            return 1
        end
        echo $argv >/tmp/_zjr_test_nosess_cmd
        return 0
    end

    zjr >/dev/null 2>&1

    set -l cmd (cat /tmp/_zjr_test_nosess_cmd)
    rm -f /tmp/_zjr_test_nosess_cmd
    functions -e ssh

    string match -q "*--layout flock-dashboard*" -- $cmd
    @status 0
end
