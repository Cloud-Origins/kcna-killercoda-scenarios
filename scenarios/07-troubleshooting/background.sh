#!/bin/bash
set -e

kubectl wait --for=condition=Ready node --all --timeout=120s
kubectl apply -f assets/broken.yaml
# Deliberately not waiting for readiness -- it isn't going to become ready
# until the learner fixes it.
