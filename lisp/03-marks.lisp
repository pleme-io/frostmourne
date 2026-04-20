;; frostmourne :: 03-marks
;; ───────────────────────
;; Directory bookmarks — type the mark name, land in the directory.
;; Resolved at rc-load so the alias body is the absolute path (no
;; runtime $HOME dance). Mirrors blzsh's `alias code='cd …'` pattern
;; with one clear declarative surface.

;; ── Workspace roots ─────────────────────────────────────────────
(defmark :name "code"    :path "$HOME/code")
(defmark :name "github"  :path "$HOME/code/github")
(defmark :name "pleme"   :path "$HOME/code/github/pleme-io")
(defmark :name "drzln"   :path "$HOME/code/github/drzln")

;; ── Primary pleme-io projects ───────────────────────────────────
(defmark :name "nix"        :path "$HOME/code/github/pleme-io/nix")
(defmark :name "frost-"     :path "$HOME/code/github/pleme-io/frost")
(defmark :name "mourne"     :path "$HOME/code/github/pleme-io/frostmourne")
(defmark :name "sub"        :path "$HOME/code/github/pleme-io/substrate")
(defmark :name "bm"         :path "$HOME/code/github/pleme-io/blackmatter")

;; ── XDG config roots ────────────────────────────────────────────
(defmark :name "cfg"        :path "${XDG_CONFIG_HOME:-$HOME/.config}")
(defmark :name "dl"         :path "$HOME/Downloads")
