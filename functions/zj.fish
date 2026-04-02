function zj --description "Start or attach to a zellij session"
    if test -n "$ZELLIJ"
        echo "Already inside a zellij session"
        return 0
    end

    if test -n "$argv[1]"
        # Attach if the session already exists, otherwise create with dashboard layout
        if zellij list-sessions 2>/dev/null | string replace -r ' .*' '' | string match -q -- $argv[1]
            zellij attach $argv[1]
        else
            zellij --layout flock-dashboard --session $argv[1]
        end
    else
        zellij --layout flock-dashboard
    end
end
