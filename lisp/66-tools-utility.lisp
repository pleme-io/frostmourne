;; frostmourne :: 66-tools-utility
;; -------------------------------
;; Rust-native utility tier bundled by frostmourne's flake.
;; blzsh-parity: every tool below is a pure-Rust classic-unix
;; replacement or observability aid. Aliases surface short names so
;; they're discoverable at the prompt.

;; ── procs: ps replacement ───────────────────────────────────────────
(defalias :name "ps-"    :value "procs")       ; avoid clobbering system ps
(defalias :name "psa"    :value "procs --tree")
(defalias :name "pst"    :value "procs --tree --sortd cpu")

;; ── sd: sed replacement (simpler regex swap) ────────────────────────
;; no alias — `sd pattern replacement <file>` is the full UX and
;; aliasing to `sed` would break scripts that expect POSIX sed.

;; ── tokei: codebase stats ───────────────────────────────────────────
(defalias :name "loc"    :value "tokei")
(defalias :name "loc-j"  :value "tokei --output json")

;; ── hyperfine: benchmarking ─────────────────────────────────────────
(defalias :name "bench"  :value "hyperfine --warmup 3")

;; ── tealdeer: tldr client ───────────────────────────────────────────
;; expose as both `tldr` (the canonical command) and the fuller name.
(defalias :name "tldr"   :value "tldr")
(defalias :name "help-"  :value "tldr")

;; ── bandwhich: per-process bandwidth ────────────────────────────────
;; sudo is usually required on Linux/macOS for raw socket access; keep
;; the alias minimal so users can decide when to sudo.
(defalias :name "bw"     :value "bandwhich")

;; ── grex: regex generator from examples ─────────────────────────────
;; `grex foo bar baz` → the least-common regex matching all three.
(defalias :name "regex"  :value "grex")

;; ── shfmt: shell script formatter ───────────────────────────────────
;; `-i 2` = 2-space indent, `-ci` = indent case labels, `-bn` = line-
;; break before `&&` / `||`. Matches the blzsh default style.
(defalias :name "shfmt-" :value "shfmt -i 2 -ci -bn")
