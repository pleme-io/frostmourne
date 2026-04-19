;; frostmourne :: 00-core
;; ─────────────────────
;; Aliases, shell options, and environment defaults that everyone
;; re-invents by hand. Lexical prefix 00 = loads first.

;; ── Navigation + listing ──────────────────────────────────────────
(defalias :name "l"    :value "ls")
(defalias :name "la"   :value "ls -A")
(defalias :name "ll"   :value "ls -la")
(defalias :name "lt"   :value "ls -la --color=always")
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

;; ── Daily ergonomics ──────────────────────────────────────────────
(defalias :name "mkd"  :value "mkdir -p")
(defalias :name "cls"  :value "clear")
(defalias :name "h"    :value "history")
(defalias :name "j"    :value "jobs -l")
(defalias :name "path" :value "echo $PATH | tr : '\\n'")

;; ── Shell options ─────────────────────────────────────────────────
;; Enable the features a modern shell assumes; turn off the annoying bell.
(defopts :enable ("extendedglob" "globdots" "promptsubst"
                  "histignoredups" "histignorespace"
                  "interactivecomments" "autocd")
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
