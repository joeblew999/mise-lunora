# CLAUDE.md

## Setup: automatic in a Code session

In a Claude Code session (the Code tab's repo picker, or `claude` run in the clone) the
SessionStart hook in `.claude/settings.json` runs `.claude/setup.sh` before your first turn.
It installs mise, the tools pinned in `mise.toml` and Lunora's Claude plugin. You can tell it
worked: the `lunora:*` skills are in your skill list and `mise` is on your PATH. Then there is
nothing to do. Don't run the setup again.

Run it by hand only when:
- the `lunora:*` skills are missing. That means a claude.ai chat session (including the phone
  app), where hooks never fire. Chat is a normal way to work on this repo, so don't tell the
  developer to switch. In chat the plugin's skills don't load either: read them from
  `~/.claude/plugins/cache/lunora/lunora/*/skills/` when needed.
- `mise.toml` changed during the session (for example after a pull), so new tools get installed.

```sh
sh .claude/setup.sh
export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$PATH"
```

It's safe to run again. It ends with `setup OK` or `setup INCOMPLETE`. Show the developer its output.

## End of every turn: check the app

You work on one app at a time, named by `APP` (`examples/<APP>`). When the developer
switches app, set it in `mise.local.toml` (see the `[env]` comment in `mise.toml`), so the
end-of-turn check looks at the right one. In a Code session a Stop hook runs
`mise run app:check` after every turn and blocks the turn if the app has errors. Hooks
don't run in a chat session, so there run `mise run app:check` yourself at the end of each turn.

## Git

Always commit straight to `main` and push. No branches, no pull requests.
