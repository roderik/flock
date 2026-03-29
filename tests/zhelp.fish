@test "zhelp prints output"
    set output (zhelp)
    test -n "$output"
    @status 0
end

@test "zhelp mentions zellij"
    set output (zhelp)
    echo $output | string match -q "*Zellij*"
    @status 0
end

@test "zhelp mentions Ctrl-p"
    set output (zhelp)
    echo $output | string match -q "*Ctrl-p*"
    @status 0
end
