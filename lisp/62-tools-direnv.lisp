;; frostmourne :: 62-tools-direnv
;; ------------------------------
;; Automatic `.envrc` loading on directory change via the built-in
;; direnv integration. One line; the recipe in
;; frost-lisp/src/integration.rs installs the chpwd hook that
;; captures `direnv export` output.
(defintegration :tool "direnv")
