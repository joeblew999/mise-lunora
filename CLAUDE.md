# CLAUDE.md

A harness for trying out Lunora's example apps the same way every time. `mise.toml` is a thin
layer that picks the app (`APP`) and calls it; each app's `package.json` does the real work.
Keep the harness simple.

## Setup: automatic in a Code session

In a Claude Code session the SessionStart hook runs `.claude/setup.sh` before your first turn:
mise, the tools in `mise.toml`, and Lunora's Claude plugin. It worked if the `lunora:*` skills
are in your skill list. Then don't run it again.

Run it by hand only if those skills are missing (a claude.ai chat or the phone app, where hooks
never fire; that's a normal way to work here, so don't tell the developer to switch), or if
`mise.toml` changed mid-session:

```sh
sh .claude/setup.sh
export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$PATH"
```

It ends with `setup OK` or `setup INCOMPLETE`; show the developer its output. In chat, read the
plugin's skills from `~/.claude/plugins/cache/lunora/lunora/*/skills/`.

## Working on an app

- One app at a time: `examples/<APP>`, default `tanstack-start-react`. For another app, set
  `APP` in `mise.local.toml` first (see `[env]` in `mise.toml`). `mise tasks` lists the commands.
- Work only in `examples/<APP>`, never in a scratch folder: mise, the hooks and the MCP server
  only work inside this repo. Changing an example is fine; `git checkout -- examples/<APP>`
  undoes it. `mise run app:create` refuses to overwrite an existing app.
- Don't write Lunora code from memory. Load the skill `lunora:lunora` routes you to first
  (`lunora-functions` for `lunora/`, `lunora-realtime` for the client).
- Lunora's MCP server (`.mcp.json`, read-only, Code sessions only) has the `lunora_*` tools:
  `lunora_search_docs` for the docs, and `lunora_list_functions`, `lunora_run_query`,
  `lunora_dev_logs` and `lunora_explain_error` to look at the real app. The app tools need
  `mise run app:dev` running in the background.

## End of every turn: check the app

In a Code session a Stop hook runs `mise run app:check`, which verifies the app if its
`lunora/` changed, and blocks the turn on errors. In chat, run it yourself.

## Git

Commit straight to `main` and push when it works. No branches, no pull requests.
