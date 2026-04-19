;; frostmourne :: 10-prompt
;; ────────────────────────
;; Two-line prompt. Top line shows context (user @ host, cwd, git branch
;; via $VAR expansion if present), bottom line is a clean %# prompt
;; character. `PROMPT_SUBST` is on so `$…` references expand each render.
;;
;; The git-branch hint works out of the box because `$FROST_GIT_BRANCH`
;; is populated by the `precmd` hook in `20-hooks.lisp` when the cwd is
;; inside a repo.

(defprompt
  :ps1 "
%F{244}╭─%f %F{green}%n%f@%F{blue}%m%f %F{244}in%f %F{cyan}%~%f%F{244}${FROST_GIT_BRANCH}%f
%F{244}╰─%f %(?.%F{green}.%F{red})%#%f "
  :ps2 "%F{244}> %f"
  :prompt-subst #t)
