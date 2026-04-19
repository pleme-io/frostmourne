;; frostmourne :: 72-tools-cloud
;; -----------------------------
;; Cloud CLI shortcuts. aws / gcloud / az don't ship universal
;; "default profile" or "most-used subcommand" behaviors, so this
;; file is thinner than the k8s one — we mostly expose sensible
;; defaults + completion specs.

;; ── AWS ────────────────────────────────────────────────────────────
(defalias :name "a"       :value "aws")
(defalias :name "awho"    :value "aws sts get-caller-identity")
(defalias :name "aec2"    :value "aws ec2")
(defalias :name "as3"     :value "aws s3")
(defalias :name "aeks"    :value "aws eks")
(defalias :name "alog"    :value "aws logs")

;; ── GCP ────────────────────────────────────────────────────────────
(defalias :name "gc"      :value "gcloud")
(defalias :name "gwho"    :value "gcloud auth list")
(defalias :name "gproj"   :value "gcloud config set project")
(defalias :name "ggke"    :value "gcloud container clusters")

;; ── Azure ──────────────────────────────────────────────────────────
(defalias :name "az-"     :value "az")   ; avoid clobbering `az` if aliased
(defalias :name "azwho"   :value "az account show")

;; ── Completion specs ──────────────────────────────────────────────
(defcompletion
  :command "aws"
  :args ("s3" "ec2" "iam" "eks" "ecs" "lambda" "logs" "rds" "sts" "ssm" "cloudformation" "cloudwatch" "route53" "dynamodb" "secretsmanager" "sns" "sqs" "kms" "sts")
  :description "AWS CLI")
(defcompletion
  :command "gcloud"
  :args ("compute" "container" "iam" "storage" "auth" "config" "functions" "pubsub" "sql" "services" "projects" "logging" "kms" "secrets" "builds" "run" "dataflow" "monitoring")
  :description "Google Cloud CLI")
(defcompletion
  :command "az"
  :args ("login" "account" "group" "vm" "storage" "keyvault" "aks" "acr" "network" "functionapp" "webapp" "monitor" "policy" "role" "appconfig" "cosmosdb" "sql")
  :description "Azure CLI")
