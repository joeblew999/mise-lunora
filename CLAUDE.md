# CLAUDE.md

## First: install mise

Before anything else, make sure mise is installed on the machine. Every tool this
repo uses (node, pnpm, lunora, wrangler) comes from `mise.toml`, so nothing works without it.

The SessionStart hook `.claude/setup-tools.sh` does this. If `mise` is not on PATH
(for example the hook didn't run), run it yourself: `sh .claude/setup-tools.sh`.

## Git

Always commit straight to `main` and push. No branches, no pull requests.
