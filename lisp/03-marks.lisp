;; frostmourne :: 03-marks
;; ───────────────────────
;; Directory bookmarks — type the mark name, land in the directory.
;; Resolved at rc-load so the alias body is the absolute path (no
;; runtime $HOME dance). Mirrors blzsh's `alias code='cd …'` pattern
;; with one clear declarative surface.
;;
;; ★ NAMING LAW — a mark name must NOT collide with a fleet CLI binary.
;; A defmark registers a `cd …` alias under its name; an alias named
;; after a command consumes argv[0] of EVERY invocation, so a mark
;; named `nix` turned `nix run .#rebuild` into a failing `cd` (the
;; 2026-06-11 defmark incident). Fleet-CLI marks therefore carry the
;; trailing-dash convention (`nix-`, `tend-`, …): typing `nix-` lands
;; you in the repo, typing `nix` reaches the binary. frost's rc-apply
;; is the backstop — it skips the alias and warns on any residual
;; collision (ApplyWarning::MarkShadowsCommand) — but the names here
;; are chosen collision-free by construction, asserted by frost-lisp's
;; `marks_do_not_shadow_fleet_clis` test against the FLEET_CLIS
;; manifest.

;; ── Workspace roots ─────────────────────────────────────────────
;; `code-` not `code`: `code` is the VS Code launcher on a dev box.
(defmark :name "code-"   :path "$HOME/code")
(defmark :name "github"  :path "$HOME/code/github")
(defmark :name "pleme"   :path "$HOME/code/github/pleme-io")
(defmark :name "drzln"   :path "$HOME/code/github/drzln")

;; ── Primary pleme-io projects (trailing-dash: names shadow CLIs) ──
(defmark :name "nix-"       :path "$HOME/code/github/pleme-io/nix")
(defmark :name "frost-"     :path "$HOME/code/github/pleme-io/frost")
(defmark :name "mourne"     :path "$HOME/code/github/pleme-io/frostmourne")
(defmark :name "sub"        :path "$HOME/code/github/pleme-io/substrate")
(defmark :name "bm"         :path "$HOME/code/github/pleme-io/blackmatter")

;; ── Most-visited fleet repos (from atuin cwd frequency) ──────────
(defmark :name "k8s"        :path "$HOME/code/github/pleme-io/k8s")
(defmark :name "theory"     :path "$HOME/code/github/pleme-io/theory")
(defmark :name "tend-"      :path "$HOME/code/github/pleme-io/tend")
(defmark :name "sui-"       :path "$HOME/code/github/pleme-io/sui")
(defmark :name "tatara-"    :path "$HOME/code/github/pleme-io/tatara")
(defmark :name "engenho-"   :path "$HOME/code/github/pleme-io/engenho")
(defmark :name "magma-"     :path "$HOME/code/github/pleme-io/magma")
(defmark :name "pangea-"    :path "$HOME/code/github/pleme-io/pangea-core")

;; ── XDG config roots ────────────────────────────────────────────
(defmark :name "cfg"        :path "${XDG_CONFIG_HOME:-$HOME/.config}")
(defmark :name "dl"         :path "$HOME/Downloads")
