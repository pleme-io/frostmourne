;; frostmourne :: 62-tools-direnv
;; ------------------------------
;; Automatic direnv `.envrc` loading on directory change. The hook
;; runs `direnv export` on chpwd, capturing its output as variable
;; assignments. Silent when direnv isn't installed.

(defhook
  :event "chpwd"
  :body "
if command -v direnv >/dev/null 2>&1; then
  eval \"$(direnv export bash 2>/dev/null)\" || true
fi")
