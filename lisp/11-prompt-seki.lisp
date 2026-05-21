;; frostmourne :: 11-prompt-seki
;; ─────────────────────────────
;; Static fallback of the seki-generated `(defprompt …)` form. The
;; canonical version is built at flake-eval time from
;; `seki init frostmourne` (see `flake.nix`'s `sekiPromptLisp`
;; derivation) and concatenated into the rc AFTER every `lisp/*.lisp`
;; file — last `defprompt` wins, so the build-time form supersedes
;; this shim AND supersedes `10-prompt.lisp`'s legacy gray/cyan
;; two-liner.
;;
;; This file exists so:
;;   1. `lisp/*.lisp` evaluation in dev / outside the nix build still
;;      yields the seki prompt (no need for the runCommand step).
;;   2. Operators reading the lisp tree see the prompt definition at
;;      a glance, not only in the flake.
;;
;; To re-generate the canonical form from a newer seki:
;;   nix run github:pleme-io/seki -- init frostmourne
;;
;; seki ships the default tier as blzsh-parity — the exact
;; Nord-snowflake prompt blzsh's starship.toml produced. Operators
;; switching from blzsh → frostmourne see the identical prompt.

;; seki :: prompt integration (auto-generated)
;; Synthesizes a `precmd` hook that captures
;; `seki prompt`'s stdout into PS1 each redraw.
;; Last `defprompt` form loaded wins — drop
;; lisp/10-prompt.lisp from your layer to use this.
(defprompt
  :command "seki prompt --status=\"$?\" --shell=frostmourne")
