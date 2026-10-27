# mise-lunora

Pinned tools for playing with [Lunora](https://github.com/anolilab/lunora).

```sh
mise install
mise run apps:verify                              # install → generate → build → verify, every app in examples/
APP=examples/tanstack-start-react mise run app:dev
```

`examples/` holds apps made with `lunora init` (default template, and `-t tanstack-start-react`).
New one: `cd examples && lunora init my-app -y`.
