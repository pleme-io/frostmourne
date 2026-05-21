;; frostmourne :: 01-blzsh-parity
;; ──────────────────────────────
;; Port of blackmatter-shell's full alias catalogue. The directive
;; (2026-05-21): operators moving from blzsh → frostmourne (mado's
;; new default shell) must lose no muscle memory. Every alias blzsh
;; ships is reachable here by the same name + same behaviour.
;;
;; Sources:
;;   - blackmatter-shell/module/groups/aliases/init.zsh (141 aliases)
;;   - blackmatter-shell/module/groups/common/settings.zsh (shopt/setopt)
;;
;; All Rust-tool replacements assume the binary is on PATH —
;; frostmourne's flake bundles bat, eza, ripgrep, fd, bottom, etc.
;; (see frostmourne/flake.nix's `bundledTools`). For tools NOT in
;; the bundled set (yazi, hexyl, fend, …), the alias is still
;; defined; running it without the binary errors loudly rather
;; than silently falling through to a different command.
;;
;; Loaded after 00-core (lexical order). Where this file repeats a
;; name from 00-core, the LATER form wins — that's intentional:
;; blzsh's behaviour shadows the older minimal default (e.g.
;; `ll = eza -l --icons …` overrides 00-core's `ll = ls -la`).

;; ── Editor: route every vim invocation through blnvim ─────────────
(defalias :name "vim"     :value "blnvim")
(defalias :name "vi"      :value "blnvim")
(defalias :name "nvim"    :value "blnvim")
(defalias :name "vimdiff" :value "blnvim -d")

;; ── Rust power-tools: replace classic-unix in place ───────────────
;; bat → cat (plain style, no pager — most callers expect dumb output).
(defalias :name "cat"  :value "bat --style=plain --paging=never")
(defalias :name "catt" :value "bat")

;; ripgrep → grep. rg handles basic grep patterns; speed gain justifies
;; learning rg flags. `grepc` adds 3-line context.
(defalias :name "grep"  :value "rg")
(defalias :name "grepc" :value "rg -C 3")

;; eza → ls family. The naked `l` / `ll` / `la` chain mirrors blzsh
;; muscle memory. `lt` is tree-mode (not the 00-core `ls -la --color`
;; form — operators expect tree).
(defalias :name "l"    :value "eza --icons --group-directories-first")
(defalias :name "ll"   :value "eza -l --icons --group-directories-first")
(defalias :name "la"   :value "eza -la --icons --group-directories-first")
(defalias :name "lt"   :value "eza -T --icons --group-directories-first")
(defalias :name "lta"  :value "eza -la --sort=modified --reverse --icons --group-directories-first")
(defalias :name "ltr"  :value "eza -l --sort=modified --reverse --icons --group-directories-first")
(defalias :name "tree" :value "eza --tree --icons")

;; blx-ls — multicall binary translating POSIX flags (-ltra) to eza
;; equivalents. Naked `ls` goes through it.
(defalias :name "ls" :value "blx-ls")

;; bottom → top/htop replacements.
(defalias :name "top"  :value "btm")
(defalias :name "htop" :value "btm")

;; Short names for Rust tools (one-off conveniences).
(defalias :name "loc"      :value "tokei")
(defalias :name "http"     :value "xh")
(defalias :name "https"    :value "xh --https")
(defalias :name "hex"      :value "hexyl")
(defalias :name "sysinfo"  :value "macchina")
(defalias :name "neofetch" :value "macchina")
(defalias :name "mcat"     :value "mdcat")
(defalias :name "fm"       :value "yazi")

;; Phase-7 Rust tool wave (calc/rga/tspin/csv/changelog/spellcheck/
;; cleanup/br/loadtest).
(defalias :name "calc"       :value "fend")
(defalias :name "rga"        :value "ripgrep-all")
(defalias :name "tspin"      :value "tailspin")
(defalias :name "csv"        :value "csvlens")
(defalias :name "changelog"  :value "git-cliff")
(defalias :name "spellcheck" :value "typos")
(defalias :name "cleanup"    :value "kondo")
(defalias :name "br"         :value "broot")
(defalias :name "loadtest"   :value "oha")

;; Rust fuzzy selectors (skim-tab binaries).
(defalias :name "fvim"  :value "skim-fvim")
(defalias :name "fco"   :value "skim-fco")
(defalias :name "fkill" :value "skim-fkill")

;; Tool wrappers (Rust-binary replacements for legacy autoload fns).
(defalias :name "bench"    :value "hyperfine")
(defalias :name "compress" :value "ouch compress")
(defalias :name "extract"  :value "ouch decompress")
(defalias :name "duh"      :value "dust -d 1")
(defalias :name "histstat" :value "atuin stats")
(defalias :name "ff"       :value "fd --type f --hidden --follow --exclude .git")
(defalias :name "fdir"     :value "fd --type d --hidden --follow --exclude .git")
(defalias :name "serve"    :value "miniserve --index index.html")
(defalias :name "myip"     :value "curl -s https://api.ipify.org && echo")
(defalias :name "b64encode" :value "base64")
(defalias :name "b64decode" :value "base64 -d")
(defalias :name "pingweb"  :value "curl -o /dev/null -s -w 'Response time: %{time_total}s\\n'")

;; Container/k8s skim-tab helpers.
(defalias :name "kexec" :value "kubectl exec -it $(skim-kpod) -- /bin/bash")
(defalias :name "klog"  :value "kubectl logs -f $(skim-kpod)")

;; Docker housekeeping.
(defalias :name "docker-clean"   :value "docker container prune -f && docker image prune -f && docker volume prune -f && docker network prune -f")
(defalias :name "docker-rm-all"  :value "docker rm $(docker ps -a -q)")
(defalias :name "docker-stop-all" :value "docker stop $(docker ps -q)")

;; Git workflows (the typed wrappers — gac/gacp/gct live in
;; blackmatter-shell as standalone binaries).
(defalias :name "gac"  :value "git-ac")
(defalias :name "gacp" :value "git-acp")
(defalias :name "gct"  :value "git-ct")

;; blx subcommands routed by name.
(defalias :name "backup"    :value "blx-backup")
(defalias :name "weather"   :value "blx-weather")
(defalias :name "json"      :value "blx-json")
(defalias :name "urlencode" :value "blx-urlencode")
(defalias :name "urldecode" :value "blx-urldecode")

;; lazygit shortcuts.
(defalias :name "lg" :value "lazygit")
(defalias :name "gg" :value "lazygit")

;; ── Cd chain ──────────────────────────────────────────────────────
;; (00-core already has .. / ... / …. ; add the four-level form.)
(defalias :name "....." :value "cd ../../../..")

;; ── Extended git ──────────────────────────────────────────────────
;; (00-core has g/ga/gc/gco/gd/gl/gp/gs/gst/gpl; add the rest.)
(defalias :name "gaa"  :value "git add --all")
(defalias :name "gcm"  :value "git commit -m")
(defalias :name "gds"  :value "git diff --staged")
(defalias :name "gla"  :value "git log --oneline --graph --decorate --all")
(defalias :name "gcb"  :value "git checkout -b")
(defalias :name "gb"   :value "git branch")
(defalias :name "gba"  :value "git branch -a")
(defalias :name "gbd"  :value "git branch -d")
(defalias :name "grb"  :value "git rebase")
(defalias :name "grbi" :value "git rebase -i")
(defalias :name "gf"   :value "git fetch")
(defalias :name "gfa"  :value "git fetch --all --prune")
(defalias :name "gpf"  :value "git push --force-with-lease")
(defalias :name "gsw"  :value "git switch")
(defalias :name "gswc" :value "git switch -c")
(defalias :name "gr"   :value "git restore")
(defalias :name "grs"  :value "git restore --staged")
(defalias :name "gstash" :value "git stash")
(defalias :name "gstp" :value "git stash pop")
(defalias :name "gstl" :value "git stash list")

;; ── Nix shortcuts ─────────────────────────────────────────────────
;; (00-core has nr/nd; add the rest. Note: blzsh uses `noglob nix`
;; because zsh tries to glob `.#syntax`; frost doesn't glob by
;; default for `defalias` substitution, so no noglob needed.)
(defalias :name "nb"   :value "nix build")
(defalias :name "ns"   :value "nix search nixpkgs")
(defalias :name "nfu"  :value "nix flake update")
(defalias :name "ngc"  :value "nix-collect-garbage -d")

;; ── Kubectl ───────────────────────────────────────────────────────
;; (00-core has k/kgp/kgs; add the rest.)
(defalias :name "kgd" :value "kubectl get deployments")
(defalias :name "kd"  :value "kubectl describe")
(defalias :name "kdp" :value "kubectl describe pod")
(defalias :name "kl"  :value "kubectl logs")
(defalias :name "klf" :value "kubectl logs -f")

;; ── Docker (00-core has d/dc; add the rest) ───────────────────────
(defalias :name "dps"  :value "docker ps")
(defalias :name "dpsa" :value "docker ps -a")
(defalias :name "di"   :value "docker images")
(defalias :name "dex"  :value "docker exec -it")
(defalias :name "dl"   :value "docker logs")
(defalias :name "dlf"  :value "docker logs -f")
(defalias :name "dcu"  :value "docker compose up")
(defalias :name "dcud" :value "docker compose up -d")
(defalias :name "dcd"  :value "docker compose down")

;; ── Cargo (00-core has c/cb/ct/cr; add the rest) ──────────────────
(defalias :name "cbr" :value "cargo build --release")
(defalias :name "cc"  :value "cargo check")
(defalias :name "cl"  :value "cargo clippy")
(defalias :name "cf"  :value "cargo fmt")
(defalias :name "cu"  :value "cargo update")

;; ── Safety wrappers ───────────────────────────────────────────────
;; -i prompts before clobber/remove. Saves novice keystroke errors.
;; `rm -i` is the blzsh default; operators who want unprompted rm
;; can use `\rm` or `command rm`.
(defalias :name "cp"    :value "cp -i")
(defalias :name "mv"    :value "mv -i")
(defalias :name "rm"    :value "rm -i")
(defalias :name "mkdir" :value "mkdir -p")
(defalias :name "df"    :value "df -h")

;; ── Convenience ───────────────────────────────────────────────────
(defalias :name "reload"  :value "exec frostmourne")  ; re-exec self
(defalias :name "shellrc" :value "blnvim ~/code/github/pleme-io/frostmourne/lisp/")
(defalias :name "py"      :value "python3")
(defalias :name "python"  :value "python3")
(defalias :name "please"  :value "sudo")
(defalias :name "pls"     :value "sudo")
