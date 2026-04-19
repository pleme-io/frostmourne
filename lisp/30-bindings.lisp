;; frostmourne :: 30-bindings
;; ──────────────────────────
;; Authoring-only today — the ZLE dispatcher that consults
;; `__frost_bind_<CANON_KEY>` in env.functions is queued for a
;; follow-up. These bindings describe the intent that lands the moment
;; the dispatcher wires up.

(defbind :key "C-x e" :action "exec $EDITOR")
(defbind :key "C-l"   :action "clear")
(defbind :key "M-?"   :action "help")
