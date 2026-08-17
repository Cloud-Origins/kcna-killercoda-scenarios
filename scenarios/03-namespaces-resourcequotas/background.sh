#!/bin/bash
set -e

kubectl wait --for=condition=Ready node --all --timeout=120s
kubectl apply -f assets/setup.yaml
kubectl wait --for=condition=Ready pod/pod-a -n team-a --timeout=60s
kubectl wait --for=condition=Ready pod/pod-b -n team-a --timeout=60s

mkdir -p /root/kcna-scratch
