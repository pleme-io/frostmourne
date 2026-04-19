;; frostmourne :: 60-tools-zoxide
;; ------------------------------
;; Wire up zoxide (smarter `cd` replacement). These forms no-op when
;; zoxide isn't installed — the hook body checks `command -v` each
;; time so missing binaries don't break the shell.
;;
;; After loading: `z <partial>` jumps to the best-matching directory
;; in your history; `zi` opens an interactive picker (requires fzf).

(defalias :name "z"  :value "zoxide query")
(defalias :name "zi" :value "zoxide query -i")

(defhook
  :event "chpwd"
  :body "
if command -v zoxide >/dev/null 2>&1; then
  zoxide add -- \"$PWD\"
fi")
