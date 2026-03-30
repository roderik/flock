# flock — init, env var defaults, and abbreviations
# Loaded automatically by fish on shell start via fisher

# ── Configurable defaults ─────────────────────────────────────────────────
set -q FLOCK_REMOTE_HOST; or set -gx FLOCK_REMOTE_HOST daystrom

# ── Zellij layout ─────────────────────────────────────────────────────────
# Fisher copies conf.d/ files, so we can't rely on a relative symlink to
# the source repo.  Write the layout directly if it's missing or outdated.
set -l _flock_layout ~/.config/zellij/layouts/flock.kdl
if not test -f $_flock_layout
    mkdir -p ~/.config/zellij/layouts
    printf '%s\n' \
        '// flock worktree tab layout (managed by flock conf.d init)' \
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
        '            pane split_direction="horizontal" size="70%" {' \
        '                pane size="80%" focus=true name="Main"' \
        '                pane size="20%" name="Terminal"' \
        '            }' \
        '            pane size="30%" name="Git" command="lazygit"' \
        '        }' \
        '    }' \
        '}' >$_flock_layout
end
set -e _flock_layout

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
