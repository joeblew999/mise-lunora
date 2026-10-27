# CLAUDE.md

## First: run the setup, every session

From the repo root, before anything else:

```sh
sh .claude/setup.sh
export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$PATH"
```

It installs mise, the tools pinned in `mise.toml` (node, pnpm, lunora) and
Lunora's Claude plugin, then prints what is installed and ends with `setup OK` or
`setup INCOMPLETE`. It is safe to run when everything is already there. Show the developer
its output. Nothing in this repo works without it.

Why by hand: the SessionStart hooks in `.claude/settings.json` only fire when Claude Code
starts with this repo as its project (the Code tab's repo picker, or `claude` run in the
clone). A session started from a claude.ai chat, including the phone app, never runs them.
Chat is a normal way to work on this repo, so don't tell the developer to switch.

In a chat session the plugin's skills and its end-of-turn check don't load. Read its
skills from `~/.claude/plugins/cache/lunora/lunora/*/skills/` when needed, and run
`lunora verify` in the app folder at the end of each turn.

## Git

Always commit straight to `main` and push. No branches, no pull requests.
