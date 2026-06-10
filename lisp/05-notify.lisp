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

;; ── DISABLED 2026-06-10 (incident: post-Enter CPR freeze) ──────────
;; The synthesized precmd hook body executes through frost's command
;; engine before EVERY prompt, and that execution wedges the next
;; read_line's cursor-position read: bisection proved this single form
;; is necessary AND sufficient to freeze the shell after the first
;; accept-line (input eaten, prompt never returns) in any terminal —
;; mado, plain PTY, regardless of DSR answer latency. Codified as the
;; #[ignore]d `notify_hook_must_not_break_cpr` persona row in
;; frost crates/frost/tests/persona_pty.rs; re-enable this form when
;; that row passes un-ignored (the frost engine-side fix).
;;
;; (defnotify
;;   :threshold-ms 30000
;;   :title        "frostmourne"
;;   :message      "command finished")
