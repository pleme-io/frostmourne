# rc anatomy

Every frostmourne experience is the concatenation of the files in
`lisp/`, loaded into frost's `ShellEnv` in lexical order.

| File | What it declares | Notes |
|------|------------------|-------|
| `00-core.lisp`        | Aliases, shell options, env vars | Runs first; later files can reference `$EDITOR` etc. |
| `10-prompt.lisp`      | (retired) the pre-seki two-liner | Fully commented out since 2026-05-21; `11-prompt-seki.lisp` renders the prompt. |
| `20-hooks.lisp`       | `precmd` / `preexec` | Stamps and publishes the command duration. Fork-free. |
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
Most domains are idempotent and order-insensitive. The two cases where
order matters:

- **`defprompt` — last one loaded wins.** `11-prompt-seki.lisp` supersedes
  the retired `10-prompt.lisp`, and the build-time `sekiPromptLisp`
  derivation appends after every `lisp/*.lisp` file, so it supersedes both.
- **`FROST_CMD_DURATION_MS`** is published by `20-hooks.lisp`'s `precmd` and
  read by the `precmd` that `05-notify.lisp`'s `(defnotify …)` synthesizes.
  It starts at 0 on the first prompt, which is correct — no command has run.

> This coupling is a string, checked by nobody, and that is a known defect
> rather than a design: `FROST_GIT_BRANCH` used to live here too and cost a
> `git` fork every prompt with **no reader anywhere in the fleet**. The typed
> replacement — beats declaring `(publish <var> <fact>)` acts instead of
> carrying shell bodies — is designed in [`frost/docs/MEGURI.md`] and is not
> implemented yet.
