;; frostmourne :: 50-functions
;; ───────────────────────────
;; Small utility functions that feel like builtins.

;; mkcd <dir> — mkdir + cd in one go.
(defun :name "mkcd"
       :body "mkdir -p \"$1\" && cd \"$1\"")

;; up [N] — cd N directories up (default 1).
(defun :name "up"
       :body "cd $(printf '../%.0s' $(seq 1 ${1:-1}))")

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
