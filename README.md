# mise-lunora

A way to try out [Lunora](https://github.com/anolilab/lunora) example apps the same way every time,
so we learn what Lunora can do and how to use it.

mise holds only what is common to every app in `examples/`; each app's own `package.json` does the rest.
Everything that matters is in `mise.toml`.

```sh
sh .claude/setup.sh   # mise, the pinned tools, Lunora's Claude plugin; ends with "setup OK"
mise tasks
```

Works the same from the Mac, a Claude Code session, or a claude.ai chat (phone included).
Claude Code sessions started with this repo as the project also run it automatically as a
start-up hook; a chat session doesn't, so Claude runs it first (see `CLAUDE.md`).
