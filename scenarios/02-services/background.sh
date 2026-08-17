#!/bin/bash
# Pre-stages the backend Deployment so the learner writes Services only,
# not the Deployment boilerplate.

set -e

kubectl wait --for=condition=Ready node --all --timeout=120s
kubectl apply -f assets/backend-deployment.yaml
kubectl wait --for=condition=Available deployment/backend --timeout=90s
