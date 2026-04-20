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
(defbind :key "C-l"   :action "clear")
(defbind :key "M-?"   :action "help")
