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

;; ── RE-ENABLED 2026-06-10 (engine fix frost 1f66d1c) ───────────────
;; This form briefly froze the shell after the first accept-line: its
;; synthesized precmd's `2>/dev/null` builtin redirect made frost cycle
;; fd 0 through dup2, deleting crossterm's kqueue registration for the
;; tty — every later cursor-position read timed out. Fixed at the root
;; (redirect::touched_std_fds — only the touched fds are cycled) and
;; pinned by the live `notify_hook_must_not_break_cpr` persona row in
;; frost crates/frost/tests/persona_pty.rs.
(defnotify
  :threshold-ms 30000
  :title        "frostmourne"
  :message      "command finished")
