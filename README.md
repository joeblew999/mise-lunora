# mise-lunora

A harness for trying out [Lunora](https://github.com/anolilab/lunora) example apps the same way
every time, so we learn what Lunora can do and how to use it. Keep it simple.

`mise.toml` is the source of truth for everything the harness does: the tools, which app is
current (`APP`), how to switch, and what each command does. It's a thin layer; each app's own
`package.json` in `examples/` does the real work. `mise tasks` lists the commands.

This README is also Claude's instructions (`CLAUDE.md` just imports it).

## Setup

**Open it in Claude Code and it sets itself up** (Claude Cloud included). A start-up hook runs
`.claude/setup.sh`, which installs mise, the tools in `mise.toml` and Lunora's Claude plugin (its
skills). `.mcp.json` adds Lunora's MCP server. Just say what you want to work on. It worked if
the `lunora:*` skills are loaded; then don't run setup again.

By hand: in a claude.ai chat or the phone app (hooks never fire there, and that's a normal way
to work on this repo), on the Mac, or after `mise.toml` changed mid-session:

```sh
sh .claude/setup.sh   # ends with "setup OK" or "setup INCOMPLETE"
export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$PATH"
```

In chat the plugin's skills don't load; read them from
`~/.claude/plugins/cache/lunora/lunora/*/skills/`.

## Working on an app

- Work only in `examples/<APP>`, never in a scratch folder: mise, the hooks and the MCP server
  only work inside this repo. Changing an example is fine; `git checkout -- examples/<APP>`
  undoes it.
- Don't write Lunora code from memory. Load the skill `lunora:lunora` routes you to first
  (`lunora-functions` for `lunora/`, `lunora-realtime` for the client).
- Use the `lunora_*` MCP tools (Code sessions only): the docs, and a look inside the real app.
- End of every turn: in a Code session a Stop hook runs `mise run app:check`. In chat, run it
  yourself.

## Git

Commit straight to `main` and push when it works. No branches, no pull requests.
