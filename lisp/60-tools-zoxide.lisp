;; frostmourne :: 60-tools-zoxide
;; ------------------------------
;; `z <partial>` jumps to the best-matching directory; `zi` opens an
;; interactive picker. Recipe installs both aliases + the chpwd hook
;; that records every directory change into zoxide's database.
(defintegration :tool "zoxide")
