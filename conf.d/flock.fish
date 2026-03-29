# flock — init, env var defaults, and abbreviations
# Loaded automatically by fish on shell start via fisher

# ── Configurable defaults ─────────────────────────────────────────────────
set -q FLOCK_REMOTE_HOST; or set -gx FLOCK_REMOTE_HOST daystrom

# ── Zellij layout symlink ─────────────────────────────────────────────────
set -l _flock_kdl (dirname (dirname (status filename)))/zellij/flock.kdl
if test -f $_flock_kdl
    mkdir -p ~/.config/zellij/layouts
    ln -sf (realpath $_flock_kdl) ~/.config/zellij/layouts/flock.kdl 2>/dev/null
end
set -e _flock_kdl

# ── Abbreviations ─────────────────────────────────────────────────────────
# f* (new short form)
abbr -a fn 'flock new'
abbr -a fd 'flock delete'
abbr -a fs 'flock tab-setup'

# wt* (backward-compat aliases)
abbr -a wtn 'flock new'
abbr -a wtd 'flock delete'
abbr -a wts 'flock tab-setup'
