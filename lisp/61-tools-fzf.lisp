;; frostmourne :: 61-tools-fzf
;; ---------------------------
;; fzf integrations. `fzf` is bundled at the flake level so these
;; forms are always resolvable inside a frostmourne session.
;;
;; Defaults:
;;   Ctrl-R → fuzzy history search (the defbind below)
;;
;; Aliases:
;;   fzf-files   pick a file   (uses fd)
;;   fzf-dirs    pick a dir
;;   fzf-history list history entries
;;
;; FZF_DEFAULT_OPTS sets a compact look & feel. Override in ~/.frostrc.lisp
;; with another (defenv :name "FZF_DEFAULT_OPTS" …) — later wins.

(defalias :name "fzf-files"   :value "fd --type f --hidden --follow --exclude .git | fzf")
(defalias :name "fzf-dirs"    :value "fd --type d --hidden --follow --exclude .git | fzf")
(defalias :name "fzf-history" :value "cat \"${HISTFILE:-$HOME/.frost_history}\" | fzf --tac --no-sort")

(defenv
  :name "FZF_DEFAULT_OPTS"
  :value "--height=40% --reverse --border --inline-info --tiebreak=end"
  :export #t)
(defenv
  :name "FZF_DEFAULT_COMMAND"
  :value "fd --type f --hidden --follow --exclude .git"
  :export #t)

;; Ctrl-R: reedline's built-in reverse-search already handles this
;; well, so the Lisp binding below is commented out. Uncomment to run
;; the fzf picker on Ctrl-R once the ZLE can splice the picked line
;; back into the edit buffer (currently ExecuteHostCommand runs the
;; string but doesn't replace the buffer).
;;
;; (defbind :key "C-r" :action "fzf-history")
