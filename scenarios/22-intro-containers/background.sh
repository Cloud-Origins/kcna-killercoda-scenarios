#!/bin/bash
set -e

kubectl wait --for=condition=Ready node --all --timeout=120s
mkdir -p /root/kcna-scratch

kubectl run runtime-demo --image=nginx:1.27 --restart=Never
kubectl wait --for=condition=Ready pod/runtime-demo --timeout=60s
