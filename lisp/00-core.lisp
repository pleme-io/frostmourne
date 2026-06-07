;; frostmourne :: 00-core
;; ─────────────────────
;; Aliases, shell options, and environment defaults that everyone
;; re-invents by hand. Lexical prefix 00 = loads first.

;; ── Navigation + listing ──────────────────────────────────────────
(defalias :name "l"    :value "ls")
(defalias :name "la"   :value "ls -A")
(defalias :name "ll"   :value "ls -la")
(defalias :name "lt"   :value "ls -la --color=always")
(defalias :name "ltra" :value "ls -ltra")   ; 489x — recent-last, the operator's reflex
(defalias :name ".."   :value "cd ..")
(defalias :name "..."  :value "cd ../..")
(defalias :name "...." :value "cd ../../..")
(defalias :name "-"    :value "cd -")

;; ── Git ───────────────────────────────────────────────────────────
(defalias :name "g"    :value "git")
(defalias :name "ga"   :value "git add")
(defalias :name "gc"   :value "git commit")
(defalias :name "gco"  :value "git checkout")
(defalias :name "gd"   :value "git diff")
(defalias :name "gl"   :value "git log --oneline --graph --decorate")
(defalias :name "gp"   :value "git push")
(defalias :name "gs"   :value "git status")
(defalias :name "gst"  :value "git status -sb")
(defalias :name "gpl"  :value "git pull")

;; ── Containers / orchestration ────────────────────────────────────
(defalias :name "d"    :value "docker")
(defalias :name "dc"   :value "docker compose")
(defalias :name "k"    :value "kubectl")
(defalias :name "kgp"  :value "kubectl get pods")
(defalias :name "kgs"  :value "kubectl get svc")

;; ── Infra / build ─────────────────────────────────────────────────
(defalias :name "tf"   :value "terraform")
(defalias :name "c"    :value "cargo")
(defalias :name "cb"   :value "cargo build")
(defalias :name "ct"   :value "cargo test")
(defalias :name "cr"   :value "cargo run")
(defalias :name "nr"   :value "nix run")
(defalias :name "nd"   :value "nix develop")
(defalias :name "rebuild" :value "nix run .#rebuild")  ; 702x — the fleet rebuild, spelled out
(defalias :name "tnd"  :value "tend")                  ; fleet workspace orchestrator

;; ── Daily ergonomics ──────────────────────────────────────────────
(defalias :name "mkd"  :value "mkdir -p")
(defalias :name "cls"  :value "clear")
;; `clear` fat-finger catches — the operator mistypes it ~4500x in history.
;; Cheap aliases that turn a "command not found" into the intended clear.
(defalias :name "claer" :value "clear")
(defalias :name "celar" :value "clear")
(defalias :name "clera" :value "clear")
(defalias :name "cler"  :value "clear")
(defalias :name "clar"  :value "clear")
(defalias :name "clea"  :value "clear")
(defalias :name "h"    :value "history")
(defalias :name "j"    :value "jobs -l")
(defalias :name "path" :value "echo $PATH | tr : '\\n'")

;; ── Shell options ─────────────────────────────────────────────────
;; Enable the features a modern shell assumes; turn off the annoying bell.
;; `vi` selects the vi keymap on day one — blzsh runs `bindkey -v`
;; unconditionally, so the operator lives in vi mode; without this frost's
;; REPL falls back to emacs, a base-keymap divergence on switchover.
(defopts :enable ("extendedglob" "globdots" "promptsubst"
                  "histignoredups" "histignorespace"
                  "interactivecomments" "autocd" "vi")
         :disable ("beep"))

;; ── Environment ───────────────────────────────────────────────────
(defenv :name "EDITOR"    :value "blnvim"      :export #t)
(defenv :name "VISUAL"    :value "blnvim"      :export #t)
(defenv :name "PAGER"     :value "less -R"     :export #t)
(defenv :name "LESS"      :value "-R --mouse"  :export #t)
(defenv :name "LANG"      :value "en_US.UTF-8" :export #t)
(defenv :name "LC_ALL"    :value "en_US.UTF-8" :export #t)
(defenv :name "CLICOLOR"  :value "1"           :export #t)
(defenv :name "TERM_COLOR_MODE" :value "truecolor")
;; ── Rust fleet defaults (cargo/Rust is the dominant workflow) ────
(defenv :name "RUST_BACKTRACE"   :value "1"      :export #t)
(defenv :name "CARGO_TERM_COLOR" :value "always" :export #t)
