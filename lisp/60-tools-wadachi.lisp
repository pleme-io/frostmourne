;; frostmourne :: 60-tools-wadachi
;; -------------------------------
;; Directory frecency is NATIVE in frost now (wadachi 轍). frost records every
;; directory change at its `chdir` chokepoint (cd / AUTO_CD / pushd / popd), and
;; the `cd` builtin falls back to the best frecency match when a bare token
;; isn't a real directory — so `cd nix` teleports to the most-worn path matching
;; "nix". There is no chpwd hook or cd-override to install (that was the zoxide
;; recipe); the only thing left is the muscle-memory `z` alias.
;;
;; `z <partial>` → `cd <partial>` → native smart-cd jumps to the best match.
;; Interactive selection is the M-c picker in 61-tools-skim (skim-cd), which
;; ranks from the same wadachi store.
(defalias :name "z" :value "cd")
