;; frostmourne :: 40-completions
;; ─────────────────────────────
;; Each `defcompletion` stores a JSON payload in
;; `__frost_complete_<command>` that frost-complete will consume when
;; its dispatcher lands. Until then, these forms validate at load time
;; and act as living documentation of the curated command vocabulary.

(defcompletion
  :command "git"
  :args ("status" "diff" "log" "commit" "push" "pull" "fetch" "rebase"
         "checkout" "branch" "merge" "stash" "reset" "restore" "show"
         "add" "rm" "mv" "tag" "remote" "clone" "init" "blame")
  :description "version control")

(defcompletion
  :command "kubectl"
  :args ("get" "describe" "apply" "delete" "logs" "exec" "port-forward"
         "rollout" "scale" "create" "edit" "config" "cluster-info"
         "top" "drain" "cordon" "uncordon")
  :description "Kubernetes CLI")

(defcompletion
  :command "docker"
  :args ("run" "exec" "build" "pull" "push" "ps" "logs" "compose"
         "images" "rm" "rmi" "inspect" "network" "volume" "stats")
  :description "container runtime")

(defcompletion
  :command "cargo"
  :args ("build" "test" "run" "check" "clippy" "fmt" "doc" "publish"
         "new" "init" "add" "remove" "update" "install" "search"
         "tree" "metadata" "bench")
  :description "Rust package manager")

(defcompletion
  :command "nix"
  :args ("build" "run" "develop" "shell" "flake" "profile" "store"
         "eval" "log" "copy" "registry" "search" "hash" "why-depends")
  :description "Nix CLI")

(defcompletion
  :command "frost"
  :args ("-c" "--command" "-i" "--interactive" "-V" "--version" "-h" "--help")
  :description "the Rust zsh-replacement")

;; ── pleme-io fleet binaries (the operator's daily verbs) ─────────
;; Clap-based, so trivially completable; surfaced here as the curated
;; vocabulary until forge-gen completions ship per-tool.
(defcompletion
  :command "tend"
  :args ("status" "sync" "reconcile" "report" "pull" "fetch" "discover" "daemon")
  :description "fleet workspace + repo orchestrator")

(defcompletion
  :command "feira"
  :args ("build" "publish" "validate" "app" "shellpkg")
  :description "caixa SDLC CLI")

(defcompletion
  :command "cordel"
  :args ("builder-wake" "cluster")
  :description "JIT remote-builder + cluster control")

(defcompletion
  :command "seki"
  :args ("init" "prompt")
  :description "typed prompt renderer")

(defcompletion
  :command "repo-forge"
  :args ("absorb" "instantiate" "migrate")
  :description "canonical repo generation")
