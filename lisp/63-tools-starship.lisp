;; frostmourne :: 63-tools-starship
;; --------------------------------
;; starship prompt integration. `defprompt :command` synthesizes a
;; `precmd` hook that captures `starship prompt`'s stdout into PS1
;; every prompt — the cleanest declarative hook-up we have.
;;
;; Disabled by default: the frost-native prompt in 10-prompt.lisp +
;; 20-hooks.lisp already gives us a two-line git/duration/status-aware
;; prompt with Nord coloring, and avoids a subprocess per prompt. If
;; you prefer starship's renderer (modules, custom segments, toml
;; config in ~/.config/starship.toml), delete 10-prompt.lisp from
;; your layer and uncomment the form below. Last prompt form wins.
;;
;; (defprompt
;;   :command "starship prompt --status=\"$?\" --cmd-duration=\"${FROST_CMD_DURATION_MS:-0}\"")
