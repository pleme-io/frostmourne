;; frostmourne :: 71-tools-git
;; ---------------------------
;; Git daily-ops shortcuts. Matches blzsh's zsh-users/zsh-git alias
;; conventions where those exist, plus pleme-io additions (delta
;; already wired in 65-tools-modern-unix as GIT_PAGER).
;;
;; The set below intentionally overlaps heavily with `oh-my-zsh`'s
;; git plugin so muscle memory transfers — no point reinventing
;; `gst`, `gco`, `gcm`.

;; ── Primary ────────────────────────────────────────────────────────
(defalias :name "g"       :value "git")

;; ── Status / info ──────────────────────────────────────────────────
(defalias :name "gs"      :value "git status -sb")
(defalias :name "gst"     :value "git status")
(defalias :name "gb"      :value "git branch")
(defalias :name "gba"     :value "git branch -a")
(defalias :name "gbd"     :value "git branch -d")

;; ── Diff / log (delta pipes via GIT_PAGER from 65-tools-modern-unix) ─
(defalias :name "gd"      :value "git diff")
(defalias :name "gds"     :value "git diff --staged")
(defalias :name "gl"      :value "git log --oneline --graph --decorate -n 20")
(defalias :name "gla"     :value "git log --oneline --graph --decorate --all -n 40")
(defalias :name "gll"     :value "git log -n 20")

;; ── Add / commit ───────────────────────────────────────────────────
(defalias :name "ga"      :value "git add")
(defalias :name "gap"     :value "git add -p")
(defalias :name "gaa"     :value "git add -A")
(defalias :name "gc"      :value "git commit")
(defalias :name "gcm"     :value "git commit -m")
(defalias :name "gca"     :value "git commit --amend")
(defalias :name "gcan"    :value "git commit --amend --no-edit")

;; ── Checkout / switch ──────────────────────────────────────────────
(defalias :name "gco"     :value "git checkout")
(defalias :name "gcob"    :value "git checkout -b")
(defalias :name "gsw"     :value "git switch")
(defalias :name "gswc"    :value "git switch -c")

;; ── Pull / push / fetch ────────────────────────────────────────────
(defalias :name "gp"      :value "git push")
(defalias :name "gpf"     :value "git push --force-with-lease")
(defalias :name "gpu"     :value "git push -u origin HEAD")
(defalias :name "gpl"     :value "git pull")
(defalias :name "gplr"    :value "git pull --rebase")
(defalias :name "gf"      :value "git fetch")
(defalias :name "gfa"     :value "git fetch --all --prune")

;; ── Stash ──────────────────────────────────────────────────────────
(defalias :name "gsta"    :value "git stash")
(defalias :name "gstp"    :value "git stash pop")
(defalias :name "gstl"    :value "git stash list")

;; ── Rebase ─────────────────────────────────────────────────────────
(defalias :name "grb"     :value "git rebase")
(defalias :name "grbm"    :value "git rebase main")
(defalias :name "grbi"    :value "git rebase -i")
(defalias :name "grbc"    :value "git rebase --continue")
(defalias :name "grba"    :value "git rebase --abort")

;; ── Reset / restore ────────────────────────────────────────────────
(defalias :name "grst"    :value "git reset")
(defalias :name "grsth"   :value "git reset --hard")
(defalias :name "grs"     :value "git restore")

;; ── Remote ─────────────────────────────────────────────────────────
(defalias :name "gr"      :value "git remote -v")
(defalias :name "gra"     :value "git remote add")

;; ── Housekeeping ───────────────────────────────────────────────────
(defalias :name "gclean"  :value "git clean -fd")
(defalias :name "gprune"  :value "git remote prune origin")

;; ── tig (if present — optional TUI) ────────────────────────────────
(defalias :name "t"       :value "tig")

;; ── Completions ────────────────────────────────────────────────────
(defcompletion
  :command "git"
  :args ("status" "add" "commit" "push" "pull" "fetch" "merge" "rebase" "checkout" "switch" "branch" "log" "diff" "stash" "reset" "restore" "clone" "remote" "tag" "show" "cherry-pick" "bisect" "blame" "reflog" "clean" "worktree" "submodule" "config" "init" "apply" "revert")
  :description "version control")
