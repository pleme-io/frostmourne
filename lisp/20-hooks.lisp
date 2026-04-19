;; frostmourne :: 20-hooks
;; ───────────────────────
;; `preexec` — record the start time of each command, so future work can
;;             show wall-clock duration in the prompt.
;; `precmd`  — populate `$FROST_GIT_BRANCH` with the current git branch
;;             (empty outside a repo). Consumed by the prompt in
;;             10-prompt.lisp.

(defhook
  :event "preexec"
  :body "FROST_CMD_START=$(date +%s)")

(defhook
  :event "precmd"
  :body "FROST_GIT_BRANCH=$(git branch --show-current 2>/dev/null | sed 's/^/ ⎇ /'); export FROST_GIT_BRANCH")
