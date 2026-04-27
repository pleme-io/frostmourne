# frostmourne

> **★★★ CSE / Knowable Construction.** This repo operates under **Constructive Substrate Engineering** — canonical specification at [`pleme-io/theory/CONSTRUCTIVE-SUBSTRATE-ENGINEERING.md`](https://github.com/pleme-io/theory/blob/main/CONSTRUCTIVE-SUBSTRATE-ENGINEERING.md). The Compounding Directive (operational rules: solve once, load-bearing fixes only, idiom-first, models stay current, direction beats velocity) is in the org-level pleme-io/CLAUDE.md ★★★ section. Read both before non-trivial changes.


Curated frost distribution — the frost analog of `blackmatter-shell` /
`blzsh`. Ships a default experience (prompt, aliases, options, hooks,
completions, keybindings) that makes `frost` feel like a batteries-
included shell out of the box. Authored **entirely in tatara-lisp**
through the [`frost-lisp`](https://github.com/pleme-io/frost/tree/main/crates/frost-lisp)
bridge — Nix just bundles the Lisp files and the wrapper binary.

## Why "frostmourne"

frost + the lich king's runeblade. The shell that carries your
configuration as a rune — declarative, authored once, lifted by
the runtime.

## What you get

Running `frostmourne` drops you into frost with:

- **Prompt** — zsh-style `%`-escape template with ANSI colors and the
  common `%~`, `%n`, `%m`, `%#`, `%(?...)` escapes.
- **Aliases** — the core set everyone re-invents (`ll`, `la`, `gst`,
  `gco`, `..`, `...`, `g`, `k`, `tf`, …).
- **Options** — `extendedglob`, `globdots`, `promptsubst`,
  `histignoredups`, with `beep` disabled.
- **Environment** — sane defaults for `EDITOR`, `PAGER`, `LESS`,
  `LANG`, `CLICOLOR`.
- **Hooks** — `preexec` timer, `precmd` exit-status marker.
- **Completions** — `git`, `kubectl`, `docker`, `cargo`, `nix`,
  `frost`.
- **Keybindings** — `C-x e` → edit in `$EDITOR`, `M-?` → help,
  `C-l` → clear.

Every one of those lives in `lisp/*.lisp` — readable, user-editable.

## Layout

```
frostmourne/
├── flake.nix              # substrate-style Nix package + HM module
├── lisp/
│   ├── 00-core.lisp       # aliases, opts, env
│   ├── 10-prompt.lisp     # defprompt
│   ├── 20-hooks.lisp      # precmd / preexec
│   ├── 30-bindings.lisp   # defbind
│   ├── 40-completions.lisp # defcompletion
│   └── 50-functions.lisp  # defun
├── module/
│   └── default.nix        # home-manager module
└── docs/
    └── rc-anatomy.md      # per-file breakdown
```

## How rc files compose

`frost-lisp` doesn't implement `(defload …)` yet, so frostmourne's
Nix derivation concatenates `lisp/*.lisp` in lexical order (the
numeric prefix ensures `00-core` before `10-prompt`, etc.) into a
single `$out/share/frostmourne/rc.lisp`. The `frostmourne` wrapper
sets `FROSTRC` to that path and `exec`s `frost`.

## Extending

Drop a new file into `lisp/` with a numeric prefix picking its place
in the load order. No Nix edits needed — the flake globs.

## Integration with the pleme-io fleet

`blackmatter-frost` (or a pleme-io/nix profile entry) enables
frostmourne and sets it as the user's login shell. Direct use for
test: `nix run github:pleme-io/frostmourne`.

See also:
- `pleme-io/frost` — the Rust shell itself
- `pleme-io/frost/crates/frost-lisp` — the def-form bridge
