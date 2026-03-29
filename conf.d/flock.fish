# flock — init, env var defaults, and abbreviations
# Loaded automatically by fish on shell start via fisher

# ── Configurable defaults ─────────────────────────────────────────────────
set -q FLOCK_ORCHESTRATOR_DIR; or set -gx FLOCK_ORCHESTRATOR_DIR ~/Development/dalp
set -q FLOCK_REMOTE_HOST; or set -gx FLOCK_REMOTE_HOST daystrom

# ── Abbreviations ─────────────────────────────────────────────────────────
# f* (new short form)
abbr -a fn 'flock new'
abbr -a fd 'flock delete'
abbr -a fo 'flock orchestrator'
abbr -a fs 'flock tab-setup'

# wt* (backward-compat aliases)
abbr -a wtn 'flock new'
abbr -a wtd 'flock delete'
abbr -a wto 'flock orchestrator'
abbr -a wts 'flock tab-setup'
