;; frostmourne :: 10-prompt
;; ────────────────────────
;; Two-line prompt, all information driven by vars the hooks in
;; 20-hooks.lisp populate each cycle. `prompt_subst` is on so `$…`
;; references expand at render time.
;;
;; Top line:  user@host in cwd ⎇ branch*  3s
;; Status:    ╰─ ✓  or  ╰─ ✗ 1
;;
;; Colors: 244 is a muted gray for decoration, green/blue/cyan for the
;; context triad, red for error states. Every `%F{…}` closes with `%f`
;; so SGR state can't leak past the prompt.

(defprompt
  :ps1 "
%F{244}╭─%f %F{green}%n%f@%F{blue}%m%f %F{244}in%f %F{cyan}%~%f%F{244}${FROST_GIT_BRANCH}%f%F{yellow}${FROST_CMD_DURATION}%f
%F{244}╰─%f ${FROST_LAST_STATUS_GLYPH}%F{244}:%f "
  :ps2 "%F{244}  %f"
  :prompt-subst #t)
