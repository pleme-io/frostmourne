;; frostmourne :: 04-history
;; ─────────────────────────
;; Consolidated history configuration — one form replaces a scatter
;; of (defenv :name "HIST*" …) + (defopts :enable ("histignore*" …)).
;;
;; ★ Effectively unlimited history.
;;
;; The fleet directive (mado → frostmourne stack) is: command history
;; never silently drops — it fills disk before exhausting itself.
;; Both `:size` (in-memory) and `:save-size` (on-disk) are pinned to
;; 100_000_000 (100M entries). At ~80 bytes/entry that's ~8GB of
;; history before the file rotates — orders of magnitude past any
;; human session lifetime. zsh under blackmatter-shell already runs
;; HISTSIZE=1_000_000; this bumps two orders further to align with
;; the "fill disk before drop" directive.
;;
;; If a future operator needs true unlimited (no cap at all), the
;; frost-lisp runtime should treat `:size 0` as unbounded; today
;; the upper bound is what frost-config parses as a u64.

(defhistory
  :file         "$HOME/.frost_history"
  :size         100000000
  :save-size    100000000
  :ignore       ("ls" "ll" "la" "pwd" "exit" "clear" "history")
  :ignore-dups  #t
  :ignore-space #t
  :extended     #t)
