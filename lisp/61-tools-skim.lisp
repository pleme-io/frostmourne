;; frostmourne :: 61-tools-skim
;; ----------------------------
;; skim (Rust fuzzy finder, binary: `sk`) + skim-tab integrations.
;; Mirrors the widget stack from `blackmatter-shell`'s
;; `skim-rs/skim/config/init.zsh` — four pickers bound to four keys,
;; authored declaratively here and dispatched by frost's REPL via the
;; `__frost_picker_*__` sentinels.
;;
;;   C-r  →  history picker     (replace buffer, user reviews + Enter)
;;   C-t  →  file picker        (append selection at cursor)
;;   M-c  →  cd picker          (becomes `cd <dir>` and auto-submits)
;;   C-f  →  content picker     (rg → skim → `$EDITOR +line path`, auto-submit)
;;
;; Each sentinel is intercepted pre-exec in `frost/src/main.rs ::
;; dispatch_picker_sentinel` — it is never parsed or executed as a
;; regular shell command.

;; ── Environment: Nord-themed skim by default ────────────────────────
;; SKIM_DEFAULT_OPTIONS is read by `sk` on every invocation. Users can
;; override in `~/.frostrc.lisp` with a later `(defenv …)` — last-wins.
(defenv
  :name "SKIM_DEFAULT_OPTIONS"
  :value "--height=40% --layout=reverse --ansi --prompt=> --color=fg:#D8DEE9,bg:#2E3440,hl:#88C0D0:bold:underlined,fg+:#ECEFF4:bold,bg+:#3B4252,hl+:#8FBCBB:bold:underlined,info:#4C566A,prompt:#A3BE8C,pointer:#88C0D0,marker:#B48EAD,spinner:#81A1C1,header:#5E81AC,border:#4C566A,query:#ECEFF4:bold"
  :export #t)
;; Seed Ctrl-T's stock skim binding (if the user keeps skim's own
;; key-bindings.zsh loaded in parallel) with the same source we use in
;; the picker — `fd` over the cwd, hidden files on, .git excluded.
(defenv
  :name "SKIM_DEFAULT_COMMAND"
  :value "fd --type f --hidden --follow --exclude .git"
  :export #t)
(defenv
  :name "SKIM_CTRL_T_COMMAND"
  :value "fd --type f --hidden --follow --exclude .git"
  :export #t)
(defenv
  :name "SKIM_ALT_C_COMMAND"
  :value "fd --type d --hidden --follow --exclude .git"
  :export #t)

;; ── Aliases: ergonomic shortcuts to the skim-tab binary set ─────────
;; skim-tab ships 9 pickers. The 4 bound to keys above are the
;; REPL-integrated ones; the others are useful standalone — surface
;; them here so `fvim`, `fco`, `fkill`, `kpod` Just Work out of the box.
(defalias :name "fh"     :value "skim-history")     ; history picker (plain stdout)
(defalias :name "ff"     :value "skim-files")       ; file picker
(defalias :name "fd-"    :value "skim-cd")          ; cd picker (paths are shell-quoted)
(defalias :name "fg"     :value "skim-content")     ; content search
(defalias :name "fvim"   :value "skim-fvim")        ; open file in $EDITOR
(defalias :name "fco"    :value "skim-fco")         ; git checkout picker
(defalias :name "fkill"  :value "skim-fkill")       ; kill picker
(defalias :name "kpod"   :value "skim-kpod")        ; k8s pod selector

;; ── Keybindings: the four skim-rs widgets ───────────────────────────
;; Bound to `__frost_picker_*__` sentinels — frost's REPL intercepts
;; them before parse/exec, runs sk in the freed terminal, and splices
;; the selection back via reedline's `run_edit_commands`.
(defbind :key "C-r" :action "__frost_picker_history__")
(defbind :key "C-t" :action "__frost_picker_files__")
(defbind :key "M-c" :action "__frost_picker_cd__")
(defbind :key "C-f" :action "__frost_picker_content__")
