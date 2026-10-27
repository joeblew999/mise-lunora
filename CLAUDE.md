# CLAUDE.md

## First: check the setup ran

A session that starts with this repo attached runs `.claude/settings.json`'s SessionStart
hooks: they install mise, the pinned tools from `mise.toml` (node, pnpm, lunora, wrangler)
and Lunora's Claude plugin. Nothing in this repo works without them.

Before doing anything else, check:

1. `command -v mise` finds mise, and
2. the `lunora:*` skills are in your skill list.

If both are true, say "Setup ran" and carry on.

If either is missing, the session did not start in this repo (for example it started empty
and the repo was cloned afterwards). Then:

- Tell Gerard straight away, in one line, that the setup didn't run and why.
- Run the hooks yourself, from the repo root:
  `sh .claude/setup-tools.sh && sh .claude/install-plugin.sh`
- Put mise on PATH for every later command:
  `export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$PATH"`
- The plugin is now installed but its skills and end-of-turn check only load in a new
  session. Until then, read its skills from `~/.claude/plugins/cache/lunora/lunora/*/skills/`
  and run `lunora verify` in the app folder at the end of each turn.
- The fix for next time is to start the session with `joeblew999/mise-lunora` attached.

## Git

Always commit straight to `main` and push. No branches, no pull requests.
