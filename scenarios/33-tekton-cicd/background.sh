#!/bin/bash
set -e

kubectl wait --for=condition=Ready node --all --timeout=120s
mkdir -p /root/kcna-scratch

# timeout so a stalled fetch fails loudly instead of hanging background.sh
# forever with no error surfaced to Killercoda's Debug panel.
timeout 60 kubectl apply -f https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml
# Tekton's images are pulled from ghcr.io, not Docker Hub -- Killercoda's
# documented image mirror cache is Docker Hub only, so this pull isn't
# guaranteed to be cached/fast. 300s absorbs a slow cold pull; this runs
# before the learner's timer starts, so extra headroom here is free.
kubectl -n tekton-pipelines wait --for=condition=Available deployment --all --timeout=300s

touch /tmp/kcna-background-done
