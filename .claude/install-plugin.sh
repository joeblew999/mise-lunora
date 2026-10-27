#!/bin/sh
# install-plugin.sh — makes sure Lunora's Claude plugin is installed for this repo.
#
# Runs as a SessionStart hook (see .claude/settings.json), so Claude gets the plugin
# on the Mac and in a Claude cloud session alike. Claude Code ignores a repo's
# plugin declaration in cloud sessions, and on the Mac only names it after the trust
# prompt without downloading it, so something has to install it.
#
# The pinned tag is read from .claude/settings.json (extraKnownMarketplaces.lunora),
# so the version lives in one place. Installs at local scope: written to
# .claude/settings.local.json in this repo (not committed), never to ~/.claude/settings.json.
# Quiet when there is nothing to do; never fails the session.

root=$(git -C "${CLAUDE_PROJECT_DIR:-.}" rev-parse --show-toplevel 2>/dev/null) || exit 0
cd "$root" || exit 0

repo=$(sed -n 's/.*"repo": *"\([^"]*\)".*/\1/p' .claude/settings.json | head -1)
ref=$(sed -n 's/.*"ref": *"\([^"]*\)".*/\1/p' .claude/settings.json | head -1)
[ -n "$repo" ] && [ -n "$ref" ] || { echo "install-plugin.sh: no lunora repo/ref in .claude/settings.json" >&2; exit 0; }

# Already installed here at this tag: nothing to do.
if grep -q "\"$ref\"" .claude/settings.local.json 2>/dev/null &&
    claude plugin list 2>/dev/null | grep -q 'lunora@lunora'; then
    exit 0
fi

# First time, or the tag was bumped: (re)add the marketplace at the pinned tag, then install.
claude plugin marketplace remove lunora --scope local >/dev/null 2>&1
claude plugin marketplace add "https://github.com/$repo.git#$ref" --scope local >/dev/null 2>&1 &&
    claude plugin install lunora@lunora --scope local -y >/dev/null 2>&1 ||
    echo "install-plugin.sh: could not install lunora@lunora at $ref" >&2
exit 0
