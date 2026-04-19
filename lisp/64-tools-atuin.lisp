;; frostmourne :: 64-tools-atuin
;; -----------------------------
;; atuin integrations. atuin is bundled; running `atuin init frost` is
;; a no-op today (atuin doesn't know frost) so we use the subset that
;; works via plain shell: `atuin search` for interactive history.
;;
;; After loading: `h` opens the full atuin search UI (interactive fzf
;; over synced history). Respects FZF_DEFAULT_OPTS for consistent
;; look & feel.

(defalias :name "h"          :value "atuin search -i")
(defalias :name "hist-stats" :value "atuin stats")
(defalias :name "hist-import" :value "atuin import auto")

(defenv :name "ATUIN_NOBIND" :value "true" :export #t)
