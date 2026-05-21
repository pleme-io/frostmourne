;; frostmourne :: 30-bindings
;; ──────────────────────────
;; Keystroke bindings that drive the ZLE. Three flavors:
;;
;;   :action "<shell>"        — runs the text as a shell command
;;                              (legacy path, wrapped in a function)
;;   :action "__frost_widget_<name>__" — dispatches to a built-in
;;                              edit-buffer widget (edit-line,
;;                              clear-screen)
;;   :action "__frost_picker_<name>__" — dispatches to a skim-backed
;;                              picker (history, files, cd, content)
;;
;; ── Authoring forms ──────────────────────────────────────────────
;;
;;   :intent ":name"  — chord sourced from `ishou_tokens::FleetKeybinds`.
;;                    Preferred for fleet-canonical chords (clear,
;;                    help, clipboard, kill-line, …). Atlas drift
;;                    becomes a build error rather than a silent
;;                    runtime miss (the 2026-05-21 Ctrl-R double-bind
;;                    incident — see 30-bindings.lisp:45 below).
;;
;;   :key "<chord>" — hard-coded chord, for app-specific bindings
;;                    that the atlas does NOT cover (e.g. mado-only
;;                    Cmd-shortcuts). Frostmourne uses :intent
;;                    everywhere it can.

;; Edit current command in $EDITOR (classic emacs/bash/zsh C-x e).
;; Two-key chord; atlas carries it verbatim via :edit-in-editor.
(defbind :intent ":edit-in-editor" :action "__frost_widget_edit_line__")

;; Clear the screen / repaint prompt (C-l fleet-canonical).
(defbind :intent ":clear-buffer"   :action "__frost_widget_clear__")

;; Show frost's cheatsheet (M-? — emacs `help-mode` muscle memory).
(defbind :intent ":help"           :action "help")

;; System-clipboard widgets — pipe the buffer through pbcopy / xclip /
;; wl-copy / xsel (first one that spawns wins). M-y mirrors the emacs
;; yank-pop idiom but targets the system clipboard; M-Y is paste.
(defbind :intent ":clipboard-copy"  :action "__frost_widget_copy-to-clipboard__")
(defbind :intent ":clipboard-paste" :action "__frost_widget_paste-from-clipboard__")

;; Kill-buffer widget — clear the entire edit buffer without
;; submitting. Bound to C-u by convention (reedline's C-u already
;; kills-to-start; this explicit widget is a user-override surface).
(defbind :intent ":kill-line" :action "__frost_widget_kill-buffer__")

;; Insert last argument of previous command — the classic bash/zsh
;; Alt-. shortcut. Reads history.previous(), pulls the trailing
;; whitespace-delimited token (preserving quoted groups), appends
;; to the current buffer with a space separator.
(defbind :intent ":insert-last-arg" :action "__frost_widget_insert-last-arg__")

;; Toggle-sudo — fish-parity M-s. Prepends "sudo " to the current
;; buffer or strips it if already present. Cleanest rescue when a
;; command fails with EACCES and you don't want to retype.
(defbind :intent ":toggle-sudo" :action "__frost_widget_toggle-sudo__")

;; Ctrl-R (history picker), Ctrl-T (files), M-c (cd), Ctrl-F (content)
;; are all declared in 61-tools-skim.lisp via `(defpicker ...)`. Do NOT
;; duplicate them here — defpicker auto-registers the binding, and an
;; explicit `(defbind :key "C-r" ...)` on top collides in reedline's
;; keybinding HashMap, leaving the chord unresponsive (incident
;; 2026-05-21). All picker bindings live in 61-tools-skim.lisp.
