# mise-lunora

Pinned tools for building apps with [Lunora](https://github.com/anolilab/lunora), plus `app:*`
tasks that run a Lunora app's steps in the right order. Inside an app it's standard Lunora and
`package.json` scripts; the tasks only fix the order.

```sh
mise install
mise run apps:verify      # every app in examples/: install → generate → build → verify
```

The tasks work on `examples/vite-react` and `examples/tanstack-start-react` (the untouched output of `lunora init app -y`). Point them at
another app with `APP=examples/other mise run app:verify`. `mise tasks` lists them alphabetically;
the order and the reason for each step are in `mise.toml`, and each task depends on the one
before it.

The pins are exact on purpose. Lunora publishes alphas several times a day, and only under the
`alpha` tag: npm's `latest` for `lunorash` is a `0.0.1` placeholder, so an unpinned install gets
nothing useful.

`lunora init` pins the project's `lunorash` to the same version as `mise.toml`. Keep the two
in step when you upgrade: the project's scripts run their own copy.

`lunora --version` prints the CLI package's own version, not `lunorash`'s. Each Lunora package is
versioned separately: `lunorash@1.0.0-alpha.437` pins `@lunora/cli@1.0.0-alpha.439` exactly.
