# mise-lunora

A way to try out [Lunora](https://github.com/anolilab/lunora) example apps the same way every time,
so we learn what Lunora can do and how to use it.

mise holds only what is common to every app in `examples/`; each app's own `package.json` does the rest.
Everything that matters is in `mise.toml`.

**Open it in Claude Code and it sets itself up.** When a Claude Code session (Claude Cloud
included) starts with this repo as its project, a start-up hook installs mise, the pinned tools
and Lunora's Claude plugin (its skills), and `.mcp.json` adds Lunora's MCP server (the docs,
and a look inside the running app). Just say what you want to work on.

By hand (a claude.ai chat, the phone app, or the Mac):

```sh
sh .claude/setup.sh   # mise, the pinned tools, Lunora's Claude plugin; ends with "setup OK"
mise tasks
```

In a chat session hooks don't fire, so Claude runs that itself first (see `CLAUDE.md`).
