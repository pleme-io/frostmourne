;; frostmourne :: 65-tools-modern-unix
;; -----------------------------------
;; Opt-in replacements for classic Unix tools. Enabling happens via
;; alias so original binaries stay reachable (`\cat`, `\ls`, `\grep`).

(defalias :name "cat"  :value "bat --plain --paging=never")
(defalias :name "less" :value "bat --paging=always")
(defalias :name "grep" :value "rg")
(defalias :name "find" :value "fd")

;; blx-ls > ls — thin Rust wrapper (pleme-io/blx) that translates
;; POSIX `ls` flags to eza equivalents. Fixes the common case
;; `ls -ltra` — eza's -t means --time (takes a value), so a raw
;; `eza -ltra` fails; blx-ls parses the cluster and invokes eza
;; with `-la --sort=modified --reverse`.
(defalias :name "ls"   :value "blx-ls")
(defalias :name "ll"   :value "eza -la --git --group-directories-first")
(defalias :name "la"   :value "eza -A --git")
(defalias :name "lt"   :value "eza -la --git --tree --level=2 --group-directories-first")
(defalias :name "lta"  :value "eza -la --sort=modified --reverse --icons --group-directories-first")
(defalias :name "ltr"  :value "eza -l --sort=modified --reverse --icons --group-directories-first")
(defalias :name "tree" :value "eza --tree --icons")

;; delta makes git diff legible.
(defenv :name "GIT_PAGER" :value "delta" :export #t)
