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

;; ── Environment: Borealis-themed skim by default ────────────────────
;; SKIM_DEFAULT_OPTIONS is read by `sk` on every invocation. Users can
;; override in `~/.frostrc.lisp` with a later `(defenv …)` — last-wins.
;;
;; Every colour below is a BORN ishou Borealis token (spec §7 skim/fzf
;; mapping) — NOT a hand-authored hex:
;;   fg=snow0 bg=night0 · hl=ice_cyan hl+=cyan_bright (M4 tier jump, no
;;   teal/cyan sibling slots) · fg+=snow2 bg+=night1 · info=shadow0 ·
;;   prompt=aurora_green pointer=green_bright · marker=solar_magenta ·
;;   spinner/header=ice_steel · border=night3 · query=snow2.
(defenv
  :name "SKIM_DEFAULT_OPTIONS"
  :value "--height=40% --layout=reverse --ansi --prompt=> --color=fg:#B5BCC9,bg:#1F222F,hl:#73C6D9:bold:underlined,fg+:#E4E8EF:bold,bg+:#2B2E3D,hl+:#7ED7EC:bold:underlined,info:#737689,prompt:#67D191,pointer:#74E29F,marker:#C673A3,spinner:#6A90C0,header:#6A90C0,border:#454859,query:#E4E8EF:bold"
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

;; ── Pickers: the four skim-rs widgets, declaratively ───────────────
;; `defpicker` is the grown-up form for binding keys to terminal-
;; takeover pickers. It encodes the full convention in one place:
;;   :name   — widget short name; becomes sentinel __frost_picker_NAME__
;;   :intent — atlas-keyword chord (preferred — sourced from
;;             ishou_tokens::FleetKeybinds; atlas drift becomes a
;;             build error rather than a silent unbound key)
;;   :key    — hard-coded chord (used when the atlas does not cover
;;             this picker; rare — every picker below has a fleet-
;;             canonical chord)
;;   :binary — what to spawn; must be on $PATH when the key fires
;;   :action — how to consume the selection:
;;       "replace"   — selection replaces buffer; user reviews + Enter
;;       "append"    — selection appends to LBUFFER (with separator)
;;       "cd-submit" — buffer becomes `cd <sel>` and auto-submits
;;       "submit"    — selection is the command verbatim; auto-submits
;;
;; The REPL sees the sentinel directly (no defbind indirection) and
;; dispatches to :binary with the live LBUFFER forwarded as `--query`.
(defpicker :name "history" :intent ":history-picker" :binary "skim-history" :action "replace")
(defpicker :name "files"   :intent ":files-picker"   :binary "skim-files"   :action "append")
(defpicker :name "cd"      :intent ":dir-picker"     :binary "skim-cd"      :action "cd-submit")
(defpicker :name "content" :intent ":content-picker" :binary "skim-content" :action "submit")
