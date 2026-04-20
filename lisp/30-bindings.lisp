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
;; C-x e is the classic emacs/bash/zsh keystroke for "open the current
;; command line in $EDITOR, edit it there, and inject the result back
;; into the prompt". frost ships this as the `edit_line` widget; it
;; writes the current buffer to a tempfile, spawns $EDITOR on it, and
;; splices the edited contents back via reedline's
;; run_edit_commands(Clear + InsertString) on the next read_line.
(defbind :key "C-x e" :action "__frost_widget_edit_line__")
(defbind :key "C-l"   :action "__frost_widget_clear__")
(defbind :key "M-?"   :action "help")

;; System-clipboard widgets — pipe the buffer through pbcopy / xclip /
;; wl-copy / xsel (first one that spawns wins). M-y mirrors the emacs
;; yank-pop idiom but targets the system clipboard; M-Y is paste.
(defbind :key "M-y"   :action "__frost_widget_copy-to-clipboard__")
(defbind :key "M-Y"   :action "__frost_widget_paste-from-clipboard__")

;; Kill-buffer widget — clear the entire edit buffer without
;; submitting. Bound to C-u by convention (reedline's C-u already
;; kills-to-start; this explicit widget is a user-override surface).
(defbind :key "C-u"   :action "__frost_widget_kill-buffer__")

;; Insert last argument of previous command — the classic bash/zsh
;; Alt-. shortcut. Reads history.previous(), pulls the trailing
;; whitespace-delimited token (preserving quoted groups), appends
;; to the current buffer with a space separator.
(defbind :key "M-."   :action "__frost_widget_insert-last-arg__")
