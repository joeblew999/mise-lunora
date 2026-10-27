# CLAUDE.md

## First: run the setup, every session

From the repo root, before anything else:

```sh
sh .claude/setup.sh
export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$PATH"
```

It installs mise, the tools pinned in `mise.toml` and
Lunora's Claude plugin, then prints what is installed and ends with `setup OK` or
`setup INCOMPLETE`. It is safe to run when everything is already there. Show the developer
its output. Nothing in this repo works without it.

Why by hand: the SessionStart hooks in `.claude/settings.json` only fire when Claude Code
starts with this repo as its project (the Code tab's repo picker, or `claude` run in the
clone). A session started from a claude.ai chat, including the phone app, never runs them.
Chat is a normal way to work on this repo, so don't tell the developer to switch.

In a chat session the plugin's skills don't load. Read them from
`~/.claude/plugins/cache/lunora/lunora/*/skills/` when needed.

## End of every turn: check the app

You work on one app at a time: `APP` in `mise.toml` names it (`examples/<APP>`). The Stop
hook in `.claude/settings.json` runs `mise run app:check` after every turn: `lunora verify`
in that app when its `lunora/` has changes, blocking the turn with the errors if it fails.
The plugin's own check doesn't do this, since it only looks in the folder Claude started in.
Hooks don't run in a chat session, so there run `APP=<name> mise run app:check` yourself
at the end of each turn.

## Git

Always commit straight to `main` and push. No branches, no pull requests.
