# mise-lunora

A way to try out [Lunora](https://github.com/anolilab/lunora) example apps the same way every time,
so we learn what Lunora can do and how to use it.

mise holds only what is common to every app in `examples/`; each app's own `package.json` does the rest.
Everything that matters is in `mise.toml`.

```sh
mise install
mise tasks
```

**Open in a Claude cloud session:** [claude.ai/code?repositories=joeblew999/mise-lunora](https://claude.ai/code?repositories=joeblew999/mise-lunora).
The session must start with this repo attached (that link, the Code tab's repository picker, or
`claude --cloud` from your clone). A session that starts empty and clones the repo later never runs
the start-up hooks below.

Claude gets Lunora's plugin automatically: a start-up hook in `.claude/settings.json` installs it
for this repo (Mac or Claude cloud). Start Claude inside `examples/<app>` when working on an app,
so the plugin's `lunora verify` check runs at the end of each turn.
