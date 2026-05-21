;; frostmourne :: 10-prompt (DEPRECATED)
;; ─────────────────────────────────────
;; SUPERSEDED 2026-05-21 by `lisp/11-prompt-seki.lisp` + the
;; build-time `sekiPromptLisp` derivation in `flake.nix`.
;;
;; The legacy gray/cyan two-liner was the pre-seki frostmourne
;; default. With seki shipped as the default prompt (typed renderer,
;; blzsh-parity Nord-snowflake palette, hot-reload via shikumi),
;; this file is intentionally left commented so:
;;
;;   1. Git history / blame shows what frostmourne used to render.
;;   2. The file name's load-order slot (10-…) stays reserved if any
;;      future prompt-related lisp form needs to land between the
;;      `00-core` baseline (00-05) and the seki form (11).
;;
;; To restore the legacy prompt: uncomment the `(defprompt …)`
;; form below AND set its filename to 19-… (or any number > 11) so
;; the load-order pushes it past the seki form.
;;
;; Two-line prompt, all information driven by vars the hooks in
;; 20-hooks.lisp populate each cycle. `promptsubst` is on (enabled in
;; 00-core's defopts) so `$…` references expand at render time.
;;
;; Left prompt, top line:
;;   user@host in cwd ⎇ branch*  3s
;; Left prompt, status line:
;;   ╰─ ✓  or  ╰─ ✗ 1
;; Right prompt (RPS1):
;;   HH:MM:SS  — a quick visual anchor for long-running work
;;
;; Colors: 244 is a muted gray for decoration, green/blue/cyan for the
;; context triad, red for error states. Every `%F{…}` closes with `%f`
;; so SGR state can't leak past the prompt.

;; (defprompt
;;   :ps1 "
;; %F{244}╭─%f %F{green}%n%f@%F{blue}%m%f %F{244}in%f %F{cyan}%~%f%F{244}${FROST_GIT_BRANCH}%f%F{yellow}${FROST_CMD_DURATION}%f
;; %F{244}╰─%f ${FROST_LAST_STATUS_GLYPH}%F{244}:%f "
;;   :ps2 "%F{244}  %f"
;;   :rps1 "%F{244}%D{%H:%M:%S}%f"
;;   :prompt-subst #t)
