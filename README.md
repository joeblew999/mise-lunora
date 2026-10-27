# mise-lunora

A small setup for trying out [Lunora](https://github.com/anolilab/lunora) example apps the same way every time.

```sh
mise install
mise run apps:verify                                         # every app in examples/: install → generate → build → verify
APP=examples/tanstack-start-react mise run app:dev           # run one app
TEMPLATE=tanstack-start-react-rspack mise run app:create     # add another lunora init template to examples/
```

## The rule: mise only holds what is common

A task goes in `mise.toml` only if it is truly common: it makes the same call into every app in
`examples/`. Each task's description says so. What a call actually runs is up to each app's own
`package.json`, and that is allowed to differ.

The calls each task makes, and what they run in each app:

| Task | Call | vite-react | tanstack-start-react | tanstack-start-react-rspack |
|---|---|---|---|---|
| `app:install` | `pnpm install` | same | same | same |
| `app:generate` | `pnpm codegen` | lunora codegen | lunora codegen | lunora codegen |
| `app:build` | `pnpm build` | tsc -b && vite build | lunora codegen && vite build | rsbuild build |
| `app:verify` | `pnpm lunora verify` | same | same | same |
| `app:dev` | `pnpm dev` | vite | vite | rsbuild dev |

If a new template lacks one of these scripts, that task is not common for it: fix that before adding
the template, rather than special-casing it in `mise.toml`.

Why the steps run in this order: `docs/2026-10-27-01-checks.md`.
