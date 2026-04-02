# flock — init, env var defaults, and abbreviations
# Loaded automatically by fish on shell start via fisher

# ── Configurable defaults ─────────────────────────────────────────────────
set -q FLOCK_REMOTE_HOST; or set -gx FLOCK_REMOTE_HOST daystrom

# ── Zellij layout ─────────────────────────────────────────────────────────
# Fisher copies conf.d/ files, so we can't rely on a relative symlink to
# the source repo.  Write the layout directly if it's missing or outdated.
set -l _flock_layout ~/.config/zellij/layouts/flock.kdl
set -l _flock_layout_v '// flock layout v2'
if not test -f $_flock_layout; or not head -1 $_flock_layout | string match -q "$_flock_layout_v*"
    mkdir -p ~/.config/zellij/layouts
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
        '                pane name="Git" command="lazygit"' \
        '            }' \
        '        }' \
        '    }' \
        '}' >$_flock_layout
end
set -e _flock_layout _flock_layout_v

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
