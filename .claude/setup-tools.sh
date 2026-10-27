#!/bin/sh
# setup-tools.sh — makes sure mise and this repo's pinned tools (mise.toml) are installed.
#
# Runs as a SessionStart hook (see .claude/settings.json), next to install-plugin.sh.
# A Claude cloud session starts in a fresh container with no mise, so none of the
# pinned tools (node, pnpm, lunora, wrangler) exist and nothing in this repo runs.
# On the Mac mise is already there, so this only runs `mise install` (a no-op when
# everything is installed).
#
# Puts mise and its shims on PATH for the rest of the session via $CLAUDE_ENV_FILE,
# so every command Claude runs uses the versions pinned in mise.toml.
# Quiet when there is nothing to do; never fails the session.

root=$(git -C "${CLAUDE_PROJECT_DIR:-.}" rev-parse --show-toplevel 2>/dev/null) || exit 0
cd "$root" || exit 0

# mise: use the one on PATH, else the one mise.run installs, else install it.
mise=$(command -v mise 2>/dev/null) || mise="$HOME/.local/bin/mise"
if [ ! -x "$mise" ]; then
    curl -fsSL https://mise.run | MISE_QUIET=1 sh >/dev/null 2>&1 && [ -x "$mise" ] ||
        { echo "setup-tools.sh: could not install mise" >&2; exit 0; }
fi

# The pinned tools from mise.toml.
"$mise" trust --quiet "$root/mise.toml" >/dev/null 2>&1
"$mise" install --quiet >/dev/null 2>&1 || echo "setup-tools.sh: mise install failed (run: mise install)" >&2

# Every later command in the session: mise itself, then the pinned tools via shims.
if [ -n "$CLAUDE_ENV_FILE" ]; then
    data="${MISE_DATA_DIR:-$HOME/.local/share/mise}"
    echo "export PATH=\"$(dirname "$mise"):$data/shims:\$PATH\"" >>"$CLAUDE_ENV_FILE"
fi
exit 0
