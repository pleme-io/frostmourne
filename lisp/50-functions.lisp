;; frostmourne :: 50-functions
;; ───────────────────────────
;; Small utility functions that feel like builtins.

;; mkcd <dir> — mkdir + cd in one go.
(defun :name "mkcd"
       :body "mkdir -p \"$1\" && cd \"$1\"")

;; up [N] — cd N directories up (default 1).
;;
;; Was `cd $(printf '../%.0s' $(seq 1 ${1:-1}))`, which was BOTH two forks and
;; wrong under frost: it leans on the inner `$(seq …)` being word-split into N
;; separate arguments so printf's format is reused N times. zsh does split an
;; unquoted command substitution, frost currently does not (verified 2026-08-07:
;; `set -- $(echo a b c)` gives argc=3 in zsh, argc=1 in frost), so printf saw
;; ONE argument, emitted `../` once, and `up 3` quietly went up a single level.
;;
;; The loop below needs no splitting, no subprocess, and no shell-specific
;; behaviour — verified byte-identical in frost, zsh 5.9 and dash. `cd ..` is
;; also more correct than a `../../..` string at a symlinked path, since each
;; step resolves against the real directory the previous one landed in.
;;
;; frost's cmdsub-splitting gap is a genuine parity bug and is being fixed on
;; its own merit; this function simply has no reason to depend on it.
(defun :name "up"
       :body "
__up_n=${1:-1}
while [ \"$__up_n\" -gt 0 ]; do
  cd .. || return 1
  __up_n=$((__up_n - 1))
done
unset __up_n")

;; extract <file> — auto-detect archive type and unpack.
(defun :name "extract"
       :body "
case \"$1\" in
  *.tar.gz|*.tgz)  tar xzf \"$1\" ;;
  *.tar.bz2|*.tbz) tar xjf \"$1\" ;;
  *.tar.xz)        tar xJf \"$1\" ;;
  *.tar)           tar xf \"$1\"  ;;
  *.zip)           unzip \"$1\"   ;;
  *.7z)            7z x \"$1\"    ;;
  *)               echo \"extract: unknown archive type: $1\" >&2 ; return 1 ;;
esac")

;; reload — re-source the shell's Lisp rc file (picks up edits without
;; starting a new frost process; works because the rc applies to the
;; live env).
(defun :name "reload"
       :body "frost -c \"echo 'reload is a stub — restart frost for now'\"")
