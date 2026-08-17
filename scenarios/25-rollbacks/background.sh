#!/bin/bash
set -e

kubectl wait --for=condition=Ready node --all --timeout=120s
mkdir -p /root/kcna-scratch

kubectl create deployment web --image=nginx:1.26 --replicas=3
kubectl rollout status deployment/web --timeout=90s
