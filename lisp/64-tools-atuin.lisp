;; frostmourne :: 64-tools-atuin
;; -----------------------------
;; atuin history aliases + ATUIN_NOBIND export. One-liner via the
;; built-in integration; the recipe defines `h`/`hist-stats`/
;; `hist-import` and sets ATUIN_NOBIND so atuin's own default keybind
;; doesn't clash with the skim-history picker bound in 61-tools-skim.
(defintegration :tool "atuin")
