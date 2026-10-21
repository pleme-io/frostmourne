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
;; ★ `shwordsplit` — POSIX field splitting for unquoted parameters.
;;
;; zsh does NOT split an unquoted `$var` into words; `sh` and `bash` do. That
;; is zsh's deliberate design and frost implements it faithfully, so
;;
;;     OPTS="-o Foo -o Bar"; ssh $OPTS host
;;
;; passes ONE argument containing spaces, and the remote tool reports something
;; unrelated-looking ("keyword ... extra arguments at end of line"). Every
;; operator reflex here comes from bash, and the failure never names the cause.
;;
;; Enabled by OPERATOR DECISION (2026-09-09) after it bit repeatedly in live
;; work. The trade is real and worth stating: any existing frostmourne script
;; relying on zsh's no-split behaviour for a value CONTAINING WHITESPACE now
;; splits. Quoting fixes those — `"$var"` is one word under every option — and
;; quoting is what the rest of the world already writes.
;;
;; Requires frost >= the commit that made the option actually DO something:
;; `ShellOption::ShWordSplit` was defined and parsed and read by nothing, so
;; `setopt shwordsplit` reported success and changed no behaviour.

;; kittykeyboard: ask the terminal for the kitty keyboard protocol while a line
;; is edited, so modified keys arrive unambiguously. This is the AUTO setting:
;; frost's line editor probes the terminal first and requests the protocol only
;; where it answers, so a terminal without it keeps the legacy keys. Requires
;; frost >= 0.1.25. A host that pushes the protocol and never pops it is cleaned
;; up by mado and tear at the next command end, so Enter at the prompt stays
;; Enter.
(defopts :enable ("extendedglob" "globdots" "promptsubst"
                  "histignoredups" "histignorespace"
                  "interactivecomments" "autocd" "vi"
                  "shwordsplit" "kittykeyboard")
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
