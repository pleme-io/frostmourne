;; frostmourne :: 05-notify
;; ────────────────────────
;; Desktop notification when a command's runtime exceeds 30 seconds.
;; Checks `$FROST_CMD_DURATION_MS` (set by the precmd hook in
;; 20-hooks.lisp) and shells out to the platform notifier:
;;
;;   macOS  — osascript `display notification`
;;   Linux  — notify-send (libnotify) / dunstify (dunst)
;;
;; Missing notifier ⇒ silent no-op; use case is "walk away while
;; the build runs, hear the beep when it's done". Users override via
;; a later (defnotify …) form (last writer wins via the hook-
;; composition pile — both bodies still fire, but a user can
;; effectively disable with a `:threshold-ms` they'll never hit).

(defnotify
  :threshold-ms 30000
  :title        "frostmourne"
  :message      "command finished")
