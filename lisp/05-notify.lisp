;; frostmourne :: 05-notify
;; ────────────────────────
;; Long-command notification. Checks `$FROST_CMD_DURATION_MS` (set by the
;; precmd hook in 20-hooks.lisp) and writes an OSC 777 to the terminal,
;; so the terminal owns the banner (mado: focus-aware, click focuses the
;; pane). No process is spawned. Text carries exit status and duration.
;;
;;   :via "osc"        — default, through the terminal
;;   :via "osascript"  — opt-in, Script-Editor-attributed banner
;;   :via "libnotify"  — opt-in, notify-send
;;   :enabled #f       — keep the form, silence it
;;
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
