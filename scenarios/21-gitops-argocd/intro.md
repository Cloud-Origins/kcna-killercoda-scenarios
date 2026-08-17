## GitOps: ArgoCD Sync & Self-Heal

ArgoCD is already installed and running in the `argocd` namespace. This is pull-based GitOps: instead of a pipeline pushing manifests to the cluster, ArgoCD continuously pulls from Git and reconciles the cluster to match -- including undoing changes that didn't come from Git.

**You will:**
1. Declare an Application pointed at a real public repo and watch it sync
2. Manually drift a resource ArgoCD owns, and prove self-heal reverts it without you touching Git

**Target time:** 50 minutes
