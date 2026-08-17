#!/bin/bash
set -e

kubectl wait --for=condition=Ready node --all --timeout=120s
mkdir -p /root/kcna-scratch

# ArgoCD's full install is heavy (repo-server, application-controller,
# server, redis, dex) -- installed here in background.sh, before the
# learner's timer starts, so none of the boot time counts against
# the 50-minute target.
kubectl create namespace argocd
# timeout so a stalled fetch fails loudly instead of hanging background.sh
# forever with no error surfaced to Killercoda's Debug panel. --server-side
# because ArgoCD's CRDs (applications.argoproj.io, applicationsets.argoproj.io)
# are large enough that a client-side apply's last-applied-configuration
# annotation exceeds Kubernetes' 262144-byte annotation limit.
timeout 60 kubectl apply --server-side --force-conflicts -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl -n argocd wait --for=condition=Available deployment/argocd-repo-server --timeout=300s
kubectl -n argocd wait --for=condition=Available deployment/argocd-server --timeout=300s
kubectl -n argocd rollout status statefulset/argocd-application-controller --timeout=300s

touch /tmp/kcna-background-done
