# KCNA Killercoda Scenarios

Compressed, hands-on Kubernetes and Cloud Native Associate (KCNA) exam-prep scenarios in Killercoda's native format. Built for the **Kubernetes African Developer Training Program 2026** (Andela x CNCF).

34 scenarios, each deployable and completable in under one hour, covering all five KCNA exam domains: Cloud Native Architecture, Container Orchestration, Kubernetes Fundamentals, Cloud Native Observability, and Cloud Native Application Delivery.

## Overview

Levels 1-21 are adapted from [`Cloud-Origins/africa-k8s-labs`](https://github.com/Cloud-Origins/africa-k8s-labs), a 19-lab KCNA track averaging roughly 34 hours to complete. Each lab was compressed to under an hour without cutting rigor -- scope was narrowed per scenario, not rushed.

Levels 22-34 are self-authored additions that close domain gaps identified against a fuller topic breakdown of the exam (container runtimes, autoscaling, serverless, CI/CD, logging, tracing, and a closing mock exam). They follow the identical file structure, compression discipline, and verification standard as 1-21.

Every scenario ships with a real, scripted `verify.sh` per step -- nothing is graded on trust. Checks read live cluster state (pod phases, endpoint IPs, HTTP responses, API query results), not object existence alone.

## Prerequisites

- A [Killercoda](https://killercoda.com/) account to run scenarios as-is, **or** a self-hosted [Educates](https://educates.dev/) instance with minor manifest translation
- Familiarity with `kubectl` -- these are exam-prep scenarios, not a Kubernetes introduction
- No local tooling required to *run* a scenario; Killercoda provisions the cluster

## Quick Start

Fork this repository, then point Killercoda's scenario importer at any scenario folder:

```bash
git clone https://github.com/Cloud-Origins/kcna-killercoda-scenarios.git
cd kcna-killercoda-scenarios

# Each folder under scenarios/ is a complete, independent Killercoda scenario
ls scenarios/
```

In Killercoda, create a new scenario from a Git repository and set the scenario path to `scenarios/01-nodes-cluster-components` (or any other level). Repeat per level, or import the whole repository as a course.

## Repository Structure

```text
kcna-killercoda-scenarios/
├── README.md
└── scenarios/
    └── NN-slug/
        ├── index.json      # Killercoda scenario manifest: title, steps, backend image
        ├── intro.md        # Shown before step 1
        ├── background.sh   # Pre-stages state; runs before the learner's timer starts
        ├── assets/         # Optional: YAML manifests referenced by step instructions
        ├── step1/
        │   ├── text.md     # Instructions for the learner
        │   └── verify.sh   # Scripted, automated grading for this step
        ├── step2/
        │   ├── text.md
        │   └── verify.sh
        └── finish.md       # Shown on completion
```

### Anatomy of a scenario manifest

`index.json` wires the files above into Killercoda's step sequence and selects the backend cluster image:

```json
{
  "title": "Nodes & Cluster Components",
  "description": "Identify control plane components and label nodes by role",
  "details": {
    "intro": { "text": "intro.md" },
    "steps": [
      { "title": "Find the control plane", "text": "step1/text.md", "verify": "step1/verify.sh" },
      { "title": "Label the worker", "text": "step2/text.md", "verify": "step2/verify.sh" }
    ],
    "finish": { "text": "finish.md" },
    "background": "background.sh"
  },
  "backend": { "imageid": "kubernetes-kubeadm-2nodes" }
}
```

## Compression Methodology

Every scenario applies one or more of the following techniques to fit real exam-relevant depth into a sub-hour session:

| Technique | Description |
|---|---|
| **Pre-staged boilerplate** | `background.sh` provisions cluster state silently, before the learner's timer starts |
| **Narrowed scope** | One tested behavior per scenario, not full lab breadth |
| **Diagnose-and-fix** | Used in place of build-from-scratch where it preserves difficulty while cutting typing time |
| **Single graded checkpoint** | One `verify.sh` per step, matching Killercoda's native per-step verification model |

## Scenario Catalog

All 34 scenarios are complete, verified, and deployable. They are organized below by KCNA exam domain, in ascending domain weight order.

### Cloud Native Architecture (12%)

| # | Scenario | Target Time | Source |
|---|---|---|---|
| 1 | Nodes & Cluster Components | 45m | `core/16-nodes-components` |
| 22 | Intro to Containers: crictl & containerd | 30m | gap-fill |
| 23 | Orchestration Why: Manual vs. Controller | 25m | gap-fill |
| 26 | HPA Autoscaling | 45m | gap-fill |
| 27 | VPA Autoscaling | 45m | gap-fill |
| 28 | Serverless: Knative Scale-to-Zero | 55m | gap-fill |
| 29 | CNCF Landscape Quiz | 25m | gap-fill |

### Container Orchestration (28%)

| # | Scenario | Target Time | Source |
|---|---|---|---|
| 2 | Services: ClusterIP -> NodePort | 45m | `core/10-services` |
| 3 | Namespaces & Resource Quotas | 40m | `core/08-namespaces-resourcequotas` |
| 4 | Persistent Storage: PV/PVC | 50m | `core/13-persistent-storage` |
| 5 | Ingress & Gateway API | 55m | `core/11-ingress-gateway` |
| 6 | Network Policies | 50m | `core/12-network-policies` |
| 7 | Troubleshooting Drill | 55m | `electives/06-troubleshooting` |

### Kubernetes Fundamentals (44%)

| # | Scenario | Target Time | Source |
|---|---|---|---|
| 8 | kubectl Tooling & Contexts | 30m | `core/17-kubectl-tooling` |
| 9 | Pods & Multi-container Patterns | 50m | `core/01-pods` |
| 10 | Labels & Selectors | 30m | `core/09-labels-selectors` |
| 11 | Fundamentals Quiz Bank | 30m | `kcna/01-fundamentals-quiz` |
| 12 | Deployments & ReplicaSets | 55m | `core/02-deployments-replicasets` |
| 13 | ConfigMaps & Secrets | 45m | `core/07-configmaps-secrets` |
| 14 | DaemonSets | 35m | `core/03-daemonsets` |
| 15 | StatefulSets | 55m | `core/04-statefulsets` |
| 16 | Jobs & CronJobs | 40m | `core/05-jobs-cronjobs` |
| 17 | Scheduling: Affinity & Taints | 55m | `core/14-scheduling` |
| 18 | Health Probes | 45m | `core/15-health-probes` |
| 24 | Rolling Updates | 35m | gap-fill |
| 25 | Rollbacks | 30m | gap-fill |

### Cloud Native Observability (12%)

| # | Scenario | Target Time | Source |
|---|---|---|---|
| 20 | Monitoring: Prometheus & Grafana | 55m | `core/18-monitoring` |
| 30 | Logging Basics | 25m | gap-fill |
| 31 | Grafana Dashboards | 45m | gap-fill |
| 32 | OpenTelemetry Traces | 50m | gap-fill |

### Cloud Native Application Delivery (16%)

| # | Scenario | Target Time | Source |
|---|---|---|---|
| 19 | Helm Packaging | 55m | `core/19-helm` |
| 21 | GitOps: ArgoCD Sync & Self-Heal (bonus) | 50m | `ckad/03-gitops-argocd` |
| 33 | Tekton CI/CD | 50m | gap-fill |

### Capstone

| # | Scenario | Target Time | Source |
|---|---|---|---|
| 34 | Final Mock Exam (all domains) | 55m | gap-fill |

> **Source** `gap-fill` denotes a self-authored scenario with no corresponding lab in `africa-k8s-labs`, added to close a domain coverage gap. All other scenarios cite their originating lab path in that repository.

## Contributing / Extending

To add a new scenario, follow the existing structure exactly:

```bash
mkdir -p scenarios/NN-slug/{step1,step2}
```

1. Write `index.json`, `intro.md`, `background.sh`, and `finish.md`.
2. For each step, write `stepN/text.md` (learner-facing instructions) and `stepN/verify.sh` (an executable script that exits `0` on success, non-zero with a clear message on failure).
3. `chmod +x background.sh step*/verify.sh`.
4. Validate the manifest: `python3 -m json.tool scenarios/NN-slug/index.json`.
5. Add a row to the appropriate domain table above.

Verification scripts must check live, observable cluster or API state -- never a static string the learner is told to echo without the system actually producing it.

## Acknowledgments

- Lab content adapted from [`Cloud-Origins/africa-k8s-labs`](https://github.com/Cloud-Origins/africa-k8s-labs)
- Scenario format: [Killercoda](https://killercoda.com/)
- Self-hosted alternative: [Educates](https://educates.dev/)
