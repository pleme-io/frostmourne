;; frostmourne :: 02-abbreviations
;; ───────────────────────────────
;; Fish-style abbreviations — SUBMIT-time expansion with the
;; expanded form visible in the terminal and recorded in history.
;;
;; Difference from aliases (00-core):
;;   (defalias :name "gco" ...)  — silent, `gco main` runs as
;;                                 `git checkout main`; history sees `gco`.
;;   (defabbr  :name "gco" ...)  — echoes `git checkout main` before
;;                                 running; history sees `git checkout`.
;;
;; When to prefer abbreviations over aliases:
;;   * You want the expansion visible in pair-programming sessions.
;;   * You want history to record the full form (grep-friendly).
;;   * You want to carry the same shortcuts into scripts (scripts read
;;     history, not in-session aliases).

;; ── Git (mirrors the common aliases but visible at submit time) ──
(defabbr :name "gca"   :expansion "git commit --amend")
(defabbr :name "gcan"  :expansion "git commit --amend --no-edit")
(defabbr :name "gcm"   :expansion "git commit -m")
(defabbr :name "gpf"   :expansion "git push --force-with-lease")
(defabbr :name "grbm"  :expansion "git rebase main")
(defabbr :name "grbi"  :expansion "git rebase -i")

;; ── Kubernetes ───────────────────────────────────────────────────
(defabbr :name "kctx"  :expansion "kubectl config current-context")
(defabbr :name "kns"   :expansion "kubectl config view --minify --output 'jsonpath={..namespace}'")

;; ── Common typo-avoiders ─────────────────────────────────────────
;; Visible expansion helps with terminal pasting — you see what will
;; actually run before hitting Enter.
(defabbr :name "psg"   :expansion "ps aux | grep -v grep | grep")
(defabbr :name "histg" :expansion "history | grep")

;; ── Highest-frequency real workflows ─────────────────────────────
;; Mined from the operator's actual history (atuin + zsh): the most-typed
;; multi-word commands. Abbreviations (not aliases) so the full command is
;; visible + history-recorded before Enter. Counts are real invocations.
(defabbr :name "gpom"  :expansion "git push origin main")  ; 1399x — #1 git workflow
(defabbr :name "gplom" :expansion "git pull origin main")  ; 1041x
(defabbr :name "nrr"   :expansion "nix run .#rebuild")     ; 702x — the fleet rebuild
(defabbr :name "gcam"  :expansion "git commit -a -m")      ; 428x

;; ── git worktrees (the `claude worktrees` fleet loop) ────────────
(defabbr :name "gwt"   :expansion "git worktree")
(defabbr :name "gwta"  :expansion "git worktree add")
(defabbr :name "gwtl"  :expansion "git worktree list")
