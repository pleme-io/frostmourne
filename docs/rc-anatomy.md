# rc anatomy

Every frostmourne experience is the concatenation of the files in
`lisp/`, loaded into frost's `ShellEnv` in lexical order.

| File | What it declares | Notes |
|------|------------------|-------|
| `00-core.lisp`        | Aliases, shell options, env vars | Runs first; later files can reference `$EDITOR` etc. |
| `10-prompt.lisp`      | `defprompt` with colors + `$VAR` hooks | Uses `$FROST_GIT_BRANCH` populated in `20-hooks`. |
| `20-hooks.lisp`       | `precmd` / `preexec` | Sets `$FROST_GIT_BRANCH`, stamps `$FROST_CMD_START`. |
| `30-bindings.lisp`    | `defbind` keybindings | Authoring-only until the ZLE dispatcher lands. |
| `40-completions.lisp` | `defcompletion` per command | Stored as JSON in `__frost_complete_<cmd>`. |
| `50-functions.lisp`   | `defun` utility functions | `mkcd`, `up`, `extract`, `reload`. |

## Extending

Drop a new file with an appropriate numeric prefix into `lisp/`:

```lisp
;; lisp/60-company.lisp
(defalias :name "aws-prod" :value "aws --profile prod")
(defenv   :name "COMPANY_API" :value "https://api.example.com")
```

No Nix edit required — `flake.nix` globs `lisp/*.lisp`.

## Loading order matters

Only when later files refer to variables/aliases set by earlier ones.
Most domains are idempotent and order-insensitive. The one case where
order matters: the prompt template references `$FROST_GIT_BRANCH`,
which is populated by the `precmd` hook at runtime — that variable
simply starts empty on the first prompt, which is fine.
