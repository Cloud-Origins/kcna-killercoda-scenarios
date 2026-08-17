#!/bin/bash
set -e

kubectl wait --for=condition=Ready node --all --timeout=120s
kubectl apply -f assets/pv.yaml
