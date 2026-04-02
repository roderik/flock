# flock — init, env var defaults, and abbreviations
# Loaded automatically by fish on shell start via fisher

# ── Configurable defaults ─────────────────────────────────────────────────
set -q FLOCK_REMOTE_HOST; or set -gx FLOCK_REMOTE_HOST daystrom

# ── Zellij layouts ────────────────────────────────────────────────────────
# Fisher copies conf.d/ files, so we can't rely on a relative symlink to
# the source repo.  Write the layouts directly if missing or outdated.
mkdir -p ~/.config/zellij/layouts

# Flock worktree tab layout
set -l _flock_layout ~/.config/zellij/layouts/flock.kdl
set -l _flock_layout_v '// flock layout v4'
if not test -f $_flock_layout; or not head -n 1 -- $_flock_layout 2>/dev/null | string match -q "$_flock_layout_v*"
    printf '%s\n' \
        "$_flock_layout_v" \
        'layout {' \
        '    default_tab_template {' \
        '        pane size=1 borderless=true {' \
        '            plugin location="zellij:tab-bar"' \
        '        }' \
        '        children' \
        '        pane size=1 borderless=true {' \
        '            plugin location="zellij:status-bar"' \
        '        }' \
        '    }' \
        '    tab {' \
        '        pane split_direction="vertical" {' \
        '            pane size="70%" focus=true name="Main"' \
        '            pane stacked=true size="30%" {' \
        '                pane name="Terminal"' \
        '                pane name="Zed" focus=true command="fish" {' \
        '                    args "-c" "__flock_zed_link (pwd); sleep infinity"' \
        '                }' \
        '                pane name="Git" command="lazygit"' \
        '                pane name="K9s" command="k9s"' \
        '            }' \
        '        }' \
        '    }' \
        '}' >$_flock_layout
end
set -e _flock_layout _flock_layout_v

# Dashboard layout (used by zj/zjr for new sessions)
set -l _dash_layout ~/.config/zellij/layouts/flock-dashboard.kdl
set -l _dash_layout_v '// flock dashboard v1'
if not test -f $_dash_layout; or not head -n 1 -- $_dash_layout 2>/dev/null | string match -q "$_dash_layout_v*"
    printf '%s\n' \
        "$_dash_layout_v" \
        'layout {' \
        '    default_tab_template {' \
        '        pane size=1 borderless=true {' \
        '            plugin location="zellij:tab-bar"' \
        '        }' \
        '        children' \
        '        pane size=1 borderless=true {' \
        '            plugin location="zellij:status-bar"' \
        '        }' \
        '    }' \
        '    tab name="Dashboard" {' \
        '        pane split_direction="vertical" {' \
        '            pane size="50%" command="btop"' \
        '            pane size="50%" focus=true' \
        '        }' \
        '    }' \
        '}' >$_dash_layout
end
set -e _dash_layout _dash_layout_v

# ── Abbreviations ─────────────────────────────────────────────────────────
# f* (new short form)
abbr -a fn 'flock new'
abbr -a fdel 'flock delete'
abbr -a fdela 'flock delete --all'
abbr -a fs 'flock tab-setup'

# wt* (backward-compat aliases)
abbr -a wtn 'flock new'
abbr -a wtd 'flock delete'
abbr -a wts 'flock tab-setup'
