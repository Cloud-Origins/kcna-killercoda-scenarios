#!/bin/bash
set -e

kubectl wait --for=condition=Ready node --all --timeout=120s
mkdir -p /root/kcna-scratch

# timeout so a stalled fetch fails loudly instead of hanging background.sh
# forever with no error surfaced to Killercoda's Debug panel.
timeout 60 kubectl apply -f https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml
kubectl -n tekton-pipelines wait --for=condition=Available deployment --all --timeout=180s
