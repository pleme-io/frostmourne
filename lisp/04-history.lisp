;; frostmourne :: 04-history
;; ─────────────────────────
;; Consolidated history configuration — one form replaces a scatter
;; of (defenv :name "HIST*" …) + (defopts :enable ("histignore*" …)).

(defhistory
  :file         "$HOME/.frost_history"
  :size         50000
  :save-size    50000
  :ignore       ("ls" "ll" "la" "pwd" "exit" "clear" "history")
  :ignore-dups  #t
  :ignore-space #t
  :extended     #t)
