;; frostmourne :: 70-tools-kubernetes
;; ----------------------------------
;; kubectl / helm / flux / kubectx / kubens / k9s / kubecolor daily-ops
;; shortcuts. Mirrors the blzsh kubernetes-tools set and
;; blackmatter-kubernetes' alias layout.
;;
;; Tool bundle (see flake.nix bundledTools):
;;   kubectl        — cluster CLI
;;   kubecolor      — colorized kubectl wrapper (bound to `k` + `kc`)
;;   kubectx        — switch contexts
;;   kubens         — switch namespaces
;;   helm           — charts
;;   flux           — GitOps
;;   k9s            — TUI
;;   k3d            — local clusters
;;   kind           — local clusters (alt)
;;   stern          — multi-pod log tailing

;; ── Primary wrapper ────────────────────────────────────────────────
(defalias :name "k"       :value "kubecolor")
(defalias :name "kc"      :value "kubecolor")
(defalias :name "kctl"    :value "kubectl")  ; bypass kubecolor for pipes

;; ── Context / namespace switching ──────────────────────────────────
(defalias :name "kcx"     :value "kubectx")
(defalias :name "kns"     :value "kubens")
(defalias :name "kcurr"   :value "kubectl config current-context")
(defalias :name "kctx"    :value "kubectx")   ; alias often used in blzsh

;; ── Resource listing (kubecolor-aware) ─────────────────────────────
(defalias :name "kpods"   :value "kubecolor get pods")
(defalias :name "ksvc"    :value "kubecolor get svc")
(defalias :name "kdep"    :value "kubecolor get deploy")
(defalias :name "ksts"    :value "kubecolor get sts")
(defalias :name "knode"   :value "kubecolor get nodes")
(defalias :name "kns-"    :value "kubecolor get ns")
(defalias :name "kev"     :value "kubecolor get events --sort-by=.lastTimestamp")
(defalias :name "ka"      :value "kubecolor get all -A")
(defalias :name "kall"    :value "kubecolor get all")

;; ── Inspection ─────────────────────────────────────────────────────
(defalias :name "kd"      :value "kubecolor describe")
(defalias :name "kdp"     :value "kubecolor describe pod")
(defalias :name "kds"     :value "kubecolor describe svc")

;; ── Logs / exec ────────────────────────────────────────────────────
(defalias :name "klog"    :value "kubecolor logs")
(defalias :name "klogf"   :value "kubecolor logs -f")
(defalias :name "ksh"     :value "kubectl exec -it")
(defalias :name "kstern"  :value "stern")

;; ── Apply / delete ─────────────────────────────────────────────────
(defalias :name "kaf"     :value "kubectl apply -f")
(defalias :name "kdel"    :value "kubectl delete")
(defalias :name "kdelf"   :value "kubectl delete -f")

;; ── Helm ───────────────────────────────────────────────────────────
(defalias :name "h"       :value "helm")
(defalias :name "hi"      :value "helm install")
(defalias :name "hu"      :value "helm upgrade")
(defalias :name "hd"      :value "helm delete")
(defalias :name "hls"     :value "helm ls -A")

;; ── Flux ───────────────────────────────────────────────────────────
(defalias :name "f"       :value "flux")
(defalias :name "fg"      :value "flux get")
(defalias :name "fgk"     :value "flux get kustomizations")
(defalias :name "fgh"     :value "flux get helmreleases")
(defalias :name "freq"    :value "flux reconcile")
(defalias :name "fres"    :value "flux suspend")
(defalias :name "ferum"   :value "flux resume")

;; ── k9s / local clusters ───────────────────────────────────────────
(defalias :name "k9"      :value "k9s")
(defalias :name "k3"      :value "k3d")

;; ── Completions the skim-tab picker + frost-complete can drive ─────
(defcompletion
  :command "k"
  :args ("apply" "get" "describe" "delete" "edit" "exec" "logs" "rollout" "scale" "explain" "cluster-info" "config" "patch" "label" "annotate" "port-forward" "cp" "top" "wait" "diff" "kustomize")
  :description "kubectl (via kubecolor)")
(defcompletion
  :command "kubectl"
  :args ("apply" "get" "describe" "delete" "edit" "exec" "logs" "rollout" "scale" "explain" "cluster-info" "config" "patch" "label" "annotate" "port-forward" "cp" "top" "wait" "diff" "kustomize")
  :description "kubernetes CLI")
(defcompletion
  :command "helm"
  :args ("install" "upgrade" "uninstall" "list" "ls" "repo" "search" "show" "template" "get" "rollback" "status" "history" "test" "lint" "dependency" "pull" "package" "push")
  :description "kubernetes package manager")
(defcompletion
  :command "flux"
  :args ("get" "create" "delete" "reconcile" "resume" "suspend" "check" "export" "uninstall" "install" "bootstrap" "diff" "logs" "stats" "events" "trace" "version")
  :description "GitOps toolkit")
