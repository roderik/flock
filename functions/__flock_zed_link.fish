function __flock_zed_link --description "Print a clickable zed:// OSC 8 hyperlink for a worktree path"
    set -l worktree_path $argv[1]
    test -n "$worktree_path"; or return

    # Convert absolute path to ~/ relative
    set -l display_path (string replace "$HOME" '~' -- $worktree_path)

    if test -n "$SSH_CONNECTION"
        set -l host $FLOCK_REMOTE_HOST
        test -n "$host"; or set host (hostname -s)
        set -l user (whoami)
        set -l url "zed://ssh/$user@$host/$display_path"
        printf '\e]8;;%s\e\\Open in Zed\e]8;;\e\\\n' $url
    else
        set -l url "zed://file$worktree_path"
        printf '\e]8;;%s\e\\Open in Zed\e]8;;\e\\\n' $url
    end
end
