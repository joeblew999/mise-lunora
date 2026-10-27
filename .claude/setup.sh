#!/bin/sh
# setup.sh — the one command that gets this repo working. Safe to run any time.
#
#   sh .claude/setup.sh
#
# Runs setup-tools.sh (mise + the tools pinned in mise.toml) and install-plugin.sh
# (Lunora's Claude plugin), then prints what is actually installed so you can see it
# worked. The SessionStart hook in .claude/settings.json runs the same two scripts, but hooks only
# fire when Claude Code starts with this repo as its project. A session started from a
# claude.ai chat never runs them, so the agent runs this by hand (see CLAUDE.md).

root=$(git -C "${CLAUDE_PROJECT_DIR:-.}" rev-parse --show-toplevel 2>/dev/null) || {
    echo "setup.sh: run me from inside the mise-lunora clone" >&2; exit 1; }
cd "$root" || exit 1

sh .claude/setup-tools.sh
sh .claude/install-plugin.sh

export PATH="$HOME/.local/bin:${MISE_DATA_DIR:-$HOME/.local/share/mise}/shims:$PATH"
ok=1

echo "== tools (mise.toml)"
if command -v mise >/dev/null 2>&1; then
    mise ls --current
    mise ls --current --missing 2>/dev/null | grep -q . && { echo "MISSING tools above: run mise install"; ok=0; }
else
    echo "MISSING: mise"; ok=0
fi

echo "== Lunora Claude plugin"
if command -v claude >/dev/null 2>&1; then
    claude plugin list 2>/dev/null | grep -A3 'lunora@lunora' || { echo "MISSING: lunora@lunora"; ok=0; }
else
    echo "no claude CLI on this machine: plugin skipped"
fi

[ "$ok" = 1 ] && echo "== setup OK" || { echo "== setup INCOMPLETE (see above)"; exit 1; }
