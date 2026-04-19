;; frostmourne :: 65-tools-modern-unix
;; -----------------------------------
;; Opt-in replacements for classic Unix tools. Enabling happens via
;; alias so original binaries stay reachable (`\cat`, `\ls`, `\grep`).

(defalias :name "cat"  :value "bat --plain --paging=never")
(defalias :name "less" :value "bat --paging=always")
(defalias :name "grep" :value "rg")
(defalias :name "find" :value "fd")

;; ls family — blzsh parity. All variants share --icons (glyphs for
;; file types) and --group-directories-first (dirs sort above files);
;; --git decorates versioned paths with their status. `l` is the
;; cheap "just list names"; `ll`/`la` add long-form + hidden-file
;; variants; `lt`/`tree` expose the tree view at depth 2; `lta`/`ltr`
;; cover reverse-chronological sorts. `ls` delegates to `blx-ls`
;; (pleme-io/blx — a Rust wrapper) which translates POSIX flag
;; clusters like `-ltra` to eza's flag model.
(defalias :name "ls"   :value "blx-ls")
(defalias :name "l"    :value "eza --icons --group-directories-first")
(defalias :name "la"   :value "eza -a --icons --group-directories-first --git")
(defalias :name "ll"   :value "eza -l --icons --group-directories-first --git")
(defalias :name "lla"  :value "eza -la --icons --group-directories-first --git")
(defalias :name "lt"   :value "eza -T --icons --group-directories-first --level=2")
(defalias :name "lta"  :value "eza -la --sort=modified --reverse --icons --group-directories-first --git")
(defalias :name "ltr"  :value "eza -l --sort=modified --reverse --icons --group-directories-first --git")
(defalias :name "tree" :value "eza --tree --icons --group-directories-first")

;; delta makes git diff legible.
(defenv :name "GIT_PAGER" :value "delta" :export #t)
