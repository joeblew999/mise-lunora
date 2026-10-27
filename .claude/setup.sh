#!/bin/sh
# setup.sh — the one command that gets this repo working. Safe to run any time.
#
#   sh .claude/setup.sh          by hand: sets up, prints what is installed, ends with
#                                "setup OK" or "setup INCOMPLETE"
#   sh .claude/setup.sh --hook   the SessionStart hook in .claude/settings.json: quiet,
#                                and never fails the session
#
# It does three things, and skips any that are already done:
#   1. installs mise
#   2. installs the tools in mise.toml
#   3. installs Lunora's Claude plugin
#
# Hooks only fire when Claude Code starts with this repo as its project. A session
# started from a claude.ai chat never runs them, so the agent runs this by hand (see README.md).

hook=; [ "$1" = "--hook" ] && hook=1
warn() { echo "setup.sh: $1" >&2; }

root=$(git -C "${CLAUDE_PROJECT_DIR:-.}" rev-parse --show-toplevel 2>/dev/null) || {
    warn "run me from inside the mise-lunora clone"; [ -n "$hook" ] && exit 0; exit 1; }
cd "$root" || exit 0

# 1. mise. A Claude cloud session starts in a fresh container with no mise, so none of
# the tools exist and nothing in this repo runs. On the Mac mise is already there.
mise=$(command -v mise 2>/dev/null) || mise="$HOME/.local/bin/mise"
if [ ! -x "$mise" ]; then
    curl -fsSL https://mise.run | MISE_QUIET=1 sh >/dev/null 2>&1 && [ -x "$mise" ] || warn "could not install mise"
fi
data="${MISE_DATA_DIR:-$HOME/.local/share/mise}"
export PATH="$(dirname "$mise"):$data/shims:$PATH"

# 2. The tools in mise.toml (a no-op when they are installed).
mise trust --quiet "$root/mise.toml" >/dev/null 2>&1
mise install --quiet >/dev/null 2>&1 || warn "mise install failed (run: mise install)"

# Every later command in the session: mise itself, then the tools via shims.
[ -n "$CLAUDE_ENV_FILE" ] && echo "export PATH=\"$(dirname "$mise"):$data/shims:\$PATH\"" >>"$CLAUDE_ENV_FILE"

# 3. Lunora's Claude plugin. Claude Code ignores a repo's plugin declaration in cloud
# sessions, and on the Mac only names it after the trust prompt without downloading it,
# so something has to install it. Its version is lunorash's version in mise.toml (the
# plugin is tagged lunorash@<version> in the Lunora repo). Installs at local scope:
# written to .claude/settings.local.json in this repo (not committed), never to
# ~/.claude/settings.json.
repo=$(sed -n 's/.*"repo": *"\([^"]*\)".*/\1/p' .claude/settings.json | head -1)
version=$(sed -n 's/^"npm:lunorash" = "\([^"]*\)".*/\1/p' mise.toml)
ref="lunorash@$version"
if ! command -v claude >/dev/null 2>&1; then
    : # no claude CLI on this machine: the report below says so
elif [ -z "$repo" ] || [ -z "$version" ]; then
    warn "no lunora repo in .claude/settings.json or lunorash in mise.toml"
elif ! { grep -q "\"$ref\"" .claude/settings.local.json 2>/dev/null &&
    claude plugin list 2>/dev/null | grep -q 'lunora@lunora'; }; then
    # First time, or the version changed: (re)add the marketplace at that tag, then install.
    claude plugin marketplace remove lunora --scope local >/dev/null 2>&1
    claude plugin marketplace add "https://github.com/$repo.git#$ref" --scope local >/dev/null 2>&1 &&
        claude plugin install lunora@lunora --scope local -y >/dev/null 2>&1 ||
        warn "could not install lunora@lunora at $ref"
fi

[ -n "$hook" ] && exit 0

# The report: what is actually installed, so you can see it worked.
ok=1
echo "== tools (mise.toml)"
if command -v mise >/dev/null 2>&1; then
    mise ls --current
    mise ls --current --missing 2>/dev/null | grep -q . && { echo "MISSING tools above: run mise install"; ok=0; }
else
    echo "MISSING: mise"; ok=0
fi

echo "== current app (mise.local.toml)"
mise exec -- sh -c 'echo "APP=$APP"'

echo "== Lunora Claude plugin"
if command -v claude >/dev/null 2>&1; then
    claude plugin list 2>/dev/null | grep -A3 'lunora@lunora' || { echo "MISSING: lunora@lunora"; ok=0; }
else
    echo "no claude CLI on this machine: plugin skipped"
fi

[ "$ok" = 1 ] && echo "== setup OK" || { echo "== setup INCOMPLETE (see above)"; exit 1; }
