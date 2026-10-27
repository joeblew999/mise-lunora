# mise-lunora

Pinned tools for building apps with [Lunora](https://github.com/anolilab/lunora).
mise gets you the tools; inside a project it's standard Lunora and `package.json` scripts.

```sh
mise install
lunora init my-app -t standalone -y   # or another template: lunora init --help
cd my-app
pnpm install
pnpm dev                              # pnpm codegen / pnpm deploy
```

The pins are exact on purpose. Lunora publishes alphas several times a day, and only under the
`alpha` tag: npm's `latest` for `lunorash` is a `0.0.1` placeholder, so an unpinned install gets
nothing useful.

`lunora init` pins the project's `lunorash` to the same version as `mise.toml`. Keep the two
in step when you upgrade: the project's scripts run their own copy.

`lunora --version` prints the CLI package's own version, not `lunorash`'s. Each Lunora package is
versioned separately: `lunorash@1.0.0-alpha.437` pins `@lunora/cli@1.0.0-alpha.439` exactly.
