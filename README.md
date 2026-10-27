# mise-lunora

Pinned tools for building apps with [Lunora](https://github.com/anolilab/lunora).

```sh
mise install
lunora init my-app
```

The pins are exact on purpose. Lunora publishes alphas several times a day, and npm's `latest`
tag for `lunorash` is a `0.0.1` placeholder, so an unpinned install gets nothing useful.

Keep the `lunorash` version in `mise.toml` the same as the one in your app's `package.json`.
The app's scripts run their own copy, and codegen output has to match the runtime.

Note: `lunora --version` on 1.0.0-alpha.437 prints `alpha.439`. The installed package is 437.
