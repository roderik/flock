function fish_tab_title --description "Tab title showing git branch context (fish 4.2+)"
    set -l branch (git branch --show-current 2>/dev/null)
    if test -n "$branch"
        if test "$argv[1]" = fish
            echo $branch
        else
            echo "$branch: $argv[1]"
        end
    else
        echo $argv[1]
    end
end
