# mise-lunora

A small setup for trying out [Lunora](https://github.com/anolilab/lunora) example apps the same way every time.

mise pins the tools (Node, pnpm, the `lunora` CLI, wrangler) and runs the steps every Lunora app shares,
in the right order. Each app's own `package.json` scripts do the rest.

```sh
mise install
mise run apps:verify                                         # every app in examples/: install → generate → build → verify
APP=examples/tanstack-start-react mise run app:dev           # run one app
TEMPLATE=tanstack-start-react-rspack mise run app:create     # add another lunora init template to examples/
```

`mise tasks` lists the steps. Why they run in this order: `docs/2026-10-27-01-checks.md`.
