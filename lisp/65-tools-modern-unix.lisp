;; frostmourne :: 65-tools-modern-unix
;; -----------------------------------
;; Opt-in replacements for classic Unix tools. Enabling happens via
;; alias so original binaries stay reachable (`\cat`, `\ls`, `\grep`).

(defalias :name "cat"  :value "bat --plain --paging=never")
(defalias :name "less" :value "bat --paging=always")
(defalias :name "grep" :value "rg")
(defalias :name "find" :value "fd")

;; eza > ls — show git status + icons when available.
(defalias :name "ls"   :value "eza --git")
(defalias :name "ll"   :value "eza -la --git --group-directories-first")
(defalias :name "la"   :value "eza -A --git")
(defalias :name "lt"   :value "eza -la --git --tree --level=2 --group-directories-first")

;; delta makes git diff legible.
(defenv :name "GIT_PAGER" :value "delta" :export #t)
