# KCNA Killercoda Scenarios

Compressed hands-on practice scenarios for KCNA exam prep, built for the Kubernetes African Developer Training Program 2026 (Andela x CNCF).

Source material: adapted from [Cloud-Origins/africa-k8s-labs](https://github.com/Cloud-Origins/africa-k8s-labs)'s 19-lab KCNA track (~34h), compressed to under 1 hour per scenario (~17h total) without cutting rigor -- scope is narrowed per scenario, not rushed.

## Compression method

Every scenario applies one or more of:
- **Pre-staged boilerplate** via `background.sh` (runs silently before the learner's timer starts)
- **Narrowed scope** -- one tested behavior per scenario, not full lab breadth
- **Diagnose-and-fix** instead of build-from-scratch where it preserves difficulty while cutting typing time
- **Single graded checkpoint** via `verify.sh`, matching Killercoda's native per-step verification

## Levels

| Level | Scenario | Chapter | Domain | Target time | Source lab | Status |
|---|---|---|---|---|---|---|
| 1 | Nodes & Cluster Components | 1-2 | Architecture (12%) | 45m | `core/16-nodes-components` | done |
| 2 | Services: ClusterIP -> NodePort | 3 | Container Orch. (28%) | 45m | `core/10-services` | done |
| 3 | Namespaces & Resource Quotas | 3 | Container Orch. (28%) | 40m | `core/08-namespaces-resourcequotas` | done |
| 4 | Persistent Storage: PV/PVC | 3 | Container Orch. (28%) | 50m | `core/13-persistent-storage` | done |
| 5 | Ingress & Gateway API | 3 | Container Orch. (28%) | 55m | `core/11-ingress-gateway` | done |
| 6 | Network Policies | 3 | Container Orch. (28%) | 50m | `core/12-network-policies` | done |
| 7 | Troubleshooting Drill | 3 | Container Orch. (28%) | 55m | `electives/06-troubleshooting` | done |
| 8 | kubectl Tooling & Contexts | 4 | K8s Fundamentals (44%) | 30m | `core/17-kubectl-tooling` | done |
| 9 | Pods & Multi-container Patterns | 4 | K8s Fundamentals (44%) | 50m | `core/01-pods` | done |
| 10 | Labels & Selectors | 4 | K8s Fundamentals (44%) | 30m | `core/09-labels-selectors` | done |
| 11 | Fundamentals Quiz Bank | 4 | K8s Fundamentals (44%) | 30m | `kcna/01-fundamentals-quiz` | done |
| 12 | Deployments & ReplicaSets | 5 | K8s Fundamentals (44%) | 55m | `core/02-deployments-replicasets` | done |
| 13 | ConfigMaps & Secrets | 5 | K8s Fundamentals (44%) | 45m | `core/07-configmaps-secrets` | done |
| 14 | DaemonSets | 5 | K8s Fundamentals (44%) | 35m | `core/03-daemonsets` | done |
| 15 | StatefulSets | 5 | K8s Fundamentals (44%) | 55m | `core/04-statefulsets` | done |
| 16 | Jobs & CronJobs | 5 | K8s Fundamentals (44%) | 40m | `core/05-jobs-cronjobs` | done |
| 17 | Scheduling: Affinity & Taints | 5 | K8s Fundamentals (44%) | 55m | `core/14-scheduling` | done |
| 18 | Health Probes | 5 | K8s Fundamentals (44%) | 45m | `core/15-health-probes` | done |
| 19 | Helm Packaging | 6 | App Delivery (16%) | 55m | `core/19-helm` | done |
| 20 | Monitoring: Prometheus & Grafana | 7 | Architecture/Observability (12%) | 55m | `core/18-monitoring` | done |
| 21 | GitOps: ArgoCD Sync & Self-Heal | 6 | App Delivery (16%) (bonus) | 50m | `ckad/03-gitops-argocd` | done |
| 22 | Intro to Containers: crictl & containerd | 1-2 | Architecture (12%) | 30m | gap-fill (self-authored) | done |
| 23 | Orchestration Why: Manual vs Controller | 1-2 | Architecture (12%) | 25m | gap-fill (self-authored) | done |
| 24 | Rolling Updates | 5 | K8s Fundamentals (44%) | 35m | gap-fill (self-authored) | done |
| 25 | Rollbacks | 5 | K8s Fundamentals (44%) | 30m | gap-fill (self-authored) | done |
| 26 | HPA Autoscaling | 1-2 | Architecture (12%) | 45m | gap-fill (self-authored) | done |
| 27 | VPA Autoscaling | 1-2 | Architecture (12%) | 45m | gap-fill (self-authored) | done |
| 28 | Serverless: Knative Scale-to-Zero | 1-2 | Architecture (12%) | 55m | gap-fill (self-authored) | done |
| 29 | CNCF Landscape Quiz | 1-2 | Architecture (12%) | 25m | gap-fill (self-authored) | done |
| 30 | Logging Basics | 7 | Observability (12%) | 25m | gap-fill (self-authored) | done |
| 31 | Grafana Dashboards | 7 | Observability (12%) | 45m | gap-fill (self-authored) | done |
| 32 | OpenTelemetry Traces | 7 | Observability (12%) | 50m | gap-fill (self-authored) | done |
| 33 | Tekton CI/CD | 6 | App Delivery (16%) | 50m | gap-fill (self-authored) | done |
| 34 | Final Mock Exam | 1-7 | All domains | 55m | gap-fill (self-authored) | done |

Levels 22-34 fill gaps identified when the roadmap was compared against a fuller 30-topic domain breakdown -- self-authored (no `africa-k8s-labs` source lab) but built to the same compression and verification standard as 1-21.

## Structure

Each scenario is a folder matching Killercoda's native format:

```
scenarios/NN-slug/
  index.json       # title, steps, backend
  intro.md
  background.sh     # pre-stages boilerplate, runs before timer starts
  step1/
    text.md
    verify.sh
  step2/
    text.md
    verify.sh
  finish.md
```

## Running a scenario

Each scenario folder is deployable as-is to Killercoda (fork this repo, point Killercoda at `scenarios/NN-slug/`) or portable to a self-hosted [Educates](https://educates.dev/) workshop with minor manifest translation.
