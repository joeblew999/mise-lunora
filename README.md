# mise-lunora

A small setup for trying out [Lunora](https://github.com/anolilab/lunora) example apps the same way every time.

mise pins the tools and runs only the steps that are common to every app in `examples/`. Each app's own
`package.json` decides what those steps actually run.

```sh
mise install
mise run apps:verify                                         # every app in examples/
APP=examples/tanstack-start-react mise run app:dev           # run one app
TEMPLATE=tanstack-start-solid mise run app:create            # add another Lunora template to examples/
```

`mise.toml` is the single source of truth: the steps, their order and why, and which templates fit.
