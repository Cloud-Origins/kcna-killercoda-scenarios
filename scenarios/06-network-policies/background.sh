#!/bin/bash
set -e

kubectl wait --for=condition=Ready node --all --timeout=120s
kubectl apply -f assets/setup.yaml
kubectl wait --for=condition=Ready pod/backend --timeout=60s
kubectl wait --for=condition=Ready pod/frontend --timeout=60s

mkdir -p /root/kcna-scratch
