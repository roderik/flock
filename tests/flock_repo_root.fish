@test "flock_repo_root returns a path when inside a git repo"
    set root (__flock_repo_root 2>/dev/null)
    test -n "$root"
    @status 0
end

@test "flock_repo_root path is a git repository"
    set root (__flock_repo_root 2>/dev/null)
    test -d "$root/.git"
    @status 0
end

@test "flock_repo_root fails outside a git repo"
    set tmpdir (mktemp -d)
    set result (cd $tmpdir; __flock_repo_root 2>&1)
    set exit_code $status
    rm -rf $tmpdir
    # Either returns non-zero or returns empty
    test $exit_code -ne 0 -o -z "$result"
    @status 0
end
