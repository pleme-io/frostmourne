;; frostmourne :: 63-tools-starship
;; --------------------------------
;; Optional: delegate the prompt to `starship` (cross-shell prompt
;; generator). Loading this file OVERRIDES the 10-prompt.lisp
;; template at apply time — later forms win for the same domain.
;;
;; Disabled by default (PS1 set via 10-prompt). Un-comment the
;; `(defprompt …)` below to enable. Requires `starship` in PATH.

;; (defprompt
;;   :ps1 "$(starship prompt)"
;;   :ps2 "%F{244}  %f"
;;   :prompt-subst #t)
