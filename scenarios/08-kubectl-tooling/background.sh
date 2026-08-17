#!/bin/bash
set -e

kubectl wait --for=condition=Ready node --all --timeout=120s
kubectl apply -f assets/setup.yaml
kubectl wait --for=condition=Ready pod/dev-worker -n dev --timeout=60s
kubectl wait --for=condition=Ready pod/staging-worker -n staging --timeout=60s
mkdir -p /root/kcna-scratch

touch /tmp/kcna-background-done
