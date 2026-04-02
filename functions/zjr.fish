function zjr --description "Start or attach to a zellij session on a remote host"
    set -l host $FLOCK_REMOTE_HOST
    if test -n "$argv[1]"
        set host $argv[1]
    end

    if test -z "$host"
        echo "Error: no remote host specified and \$FLOCK_REMOTE_HOST is not set" >&2
        return 1
    end

    # Check for existing sessions on the remote host
    # Strip ANSI escape codes and carriage returns from remote output
    set -l sessions (ssh $host "zellij list-sessions 2>/dev/null" | string replace -ra '\e\[[0-9;]*m' '' | string replace -ra '\r' '' | string collect)

    if test -n "$sessions"
        set -l session_lines (string split \n -- $sessions)
        set -l session_names
        for line in $session_lines
            if test -n "$line"
                # Session name is the first word on the line
                set -a session_names (string split " " -- $line)[1]
            end
        end

        if test (count $session_names) -gt 0
            echo "Existing sessions on $host:"
            for i in (seq (count $session_names))
                echo "  $i) $session_names[$i]"
            end
            echo "  n) New session"
            echo ""
            read -P "Select session: " choice

            if test "$choice" = n
                ssh -t $host "zellij --layout flock-dashboard 2>/dev/null || zellij"
                return
            end

            # Treat as a number
            if string match -qr '^\d+$' -- $choice
                if test $choice -ge 1 -a $choice -le (count $session_names)
                    ssh -t $host "zellij attach '$session_names[$choice]'"
                    return
                end
            end

            echo "Invalid selection" >&2
            return 1
        end
    end

    # No existing sessions — start a new one
    ssh -t $host "zellij --layout flock-dashboard 2>/dev/null || zellij"
end
